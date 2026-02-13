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
