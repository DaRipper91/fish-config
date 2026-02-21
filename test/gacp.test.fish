# test/gacp.test.fish

# Source the function relative to the test file location
set -l script_dir (dirname (status filename))
set -l function_path "$script_dir/../functions/gacp.fish"

if test -f "$function_path"
    source "$function_path"
else
    echo "❌ Error: Could not find function at $function_path"
    exit 1
end

echo "🧪 Testing gacp function..."

# Mock git function
function git
    set -l cmd $argv[1]
    switch $cmd
        case add
            if test "$argv[2]" = "."
                echo "MOCK: git add ."
                return 0
            else
                echo "MOCK: git add failed (wrong args)"
                return 1
            end
        case commit
            if string match -q -- "-m" $argv[2]
                echo "MOCK: git commit -m \"$argv[3]\""
                return 0
            else
                return 1
            end
        case push
            echo "MOCK: git push"
            return 0
        case '*'
            echo "Unknown git command: $cmd"
            return 1
    end
end

# Test 1: Empty args
echo ":: Test 1: Empty arguments (should fail)"
if gacp
    echo "❌ Test 1 FAILED: Should have returned error status"
    exit 1
else
    echo "✅ Test 1 PASSED: Returned error status as expected"
end

# Test 2: Success path
echo ":: Test 2: Normal usage (should succeed)"
if gacp "test commit"
    echo "✅ Test 2 PASSED"
else
    echo "❌ Test 2 FAILED: Function returned error"
    exit 1
end

# Test 3: Git add failure (mocking failure)
# Redefine git to fail on add
function git
    if test "$argv[1]" = "add"
        return 1
    end
    return 0
end

echo ":: Test 3: Git add failure (should fail)"
if gacp "fail commit"
    echo "❌ Test 3 FAILED: Should have stopped on git add failure"
    exit 1
else
    echo "✅ Test 3 PASSED: Stopped correctly"
end

echo "🎉 All gacp tests passed!"
# 1. Source the function
source functions/gacp.fish

# 2. Mock state variables
set -g MOCK_IS_GIT_REPO 0      # 0 = true (success), 1 = false (error)
set -g MOCK_GIT_STATUS ""      # Empty = clean
set -g MOCK_ARGS ""            # Arguments passed to mock git

# 3. Define the mock
function git
    set -l cmd $argv[1]

    # Store args for verification
    set -g MOCK_ARGS $MOCK_ARGS "git $argv"

    if test "$cmd" = "rev-parse"
        return $MOCK_IS_GIT_REPO
    else if test "$cmd" = "status"
        if contains -- "--porcelain" $argv
            echo "$MOCK_GIT_STATUS"
        else if contains -- "--short" $argv
            echo "$MOCK_GIT_STATUS"
        end
        return 0
    else if test "$cmd" = "add"
        return 0
    else if test "$cmd" = "commit"
        return 0
    else if test "$cmd" = "push"
        return 0
    end
end

# 4. Helper to reset state
function reset_mock
    set -g MOCK_IS_GIT_REPO 0
    set -g MOCK_GIT_STATUS ""
    set -g MOCK_ARGS ""
end

echo "🚀 Running GACP Tests..."

# Test 1: Not a git repo
reset_mock
set MOCK_IS_GIT_REPO 1
set output (gacp "msg" 2>&1)
if string match -q "*Not a git repository*" "$output"
    echo "✅ PASS: Detected non-git repo"
else
    echo "❌ FAIL: Expected 'Not a git repository', got: $output"
    # Don't exit yet to see other failures
end

# Test 2: Clean repo (no changes)
reset_mock
set MOCK_IS_GIT_REPO 0
set MOCK_GIT_STATUS ""
set output (gacp "msg" 2>&1)
if string match -q "*Clean working directory*" "$output"
    echo "✅ PASS: Detected clean repo"
else
    echo "❌ FAIL: Expected 'Clean working directory', got: $output"
end

# Test 3: Dirty repo, message provided
reset_mock
set MOCK_IS_GIT_REPO 0
set MOCK_GIT_STATUS "M file.txt"
set output (gacp "feat: new feature" 2>&1)
# Verify correct commit command was called
if string match -q "*git commit -m feat: new feature*" "$MOCK_ARGS"
    echo "✅ PASS: Committed with arguments"
else
    echo "❌ FAIL: Expected commit with message, got args: $MOCK_ARGS"
end

# Test 4: Dirty repo, input piped (missing arg)
reset_mock
set MOCK_IS_GIT_REPO 0
set MOCK_GIT_STATUS "M file.txt"
# Pipe input to simulate user typing
set output (echo "fix: bug fix" | gacp 2>&1)
if string match -q "*git commit -m fix: bug fix*" "$MOCK_ARGS"
    echo "✅ PASS: Committed with piped input"
else
    echo "❌ FAIL: Expected piped commit message, got args: $MOCK_ARGS"
end

echo "🏁 GACP Tests Complete"
