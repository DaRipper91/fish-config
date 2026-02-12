# Test for gacp.fish

# Mock git
function git
    set -l subcommand $argv[1]

    # Mock failure scenarios based on environment variable
    if test "$FAIL_ON" = "$subcommand"
        echo "Mocking git failure for $subcommand"
        return 1
    end

    if test "$subcommand" = "commit"
        if test (count $argv) -lt 3
            echo "git commit failed: missing message"
            return 1
        end
    end

    echo "git $argv"
    return 0
end

source functions/gacp.fish

echo "--- Test 1: Missing commit message ---"
set output (gacp 2>&1)
set status_code $status

if test $status_code -eq 1
    echo "PASS: Status code 1 on missing message"
else
    echo "FAIL: Expected status 1, got $status_code"
    echo "Output: $output"
    exit 1
end

if string match -q "*Error: Missing commit message*" "$output"
    echo "PASS: Output contains error message"
else
    echo "FAIL: Expected error message, got '$output'"
    exit 1
end


echo "--- Test 2: git add failure ---"
set -x FAIL_ON add
set output (gacp "test message" 2>&1)
set status_code $status
set -e FAIL_ON

if test $status_code -eq 1
    echo "PASS: Status code 1 on git add failure"
else
    echo "FAIL: Expected status 1, got $status_code"
    echo "Output: $output"
    exit 1
end

if string match -q "*Failed to stage changes*" "$output"
    echo "PASS: Output contains failure message"
else
    echo "FAIL: Expected failure message, got '$output'"
    exit 1
end

if string match -q "*Committing:*" "$output"
    echo "FAIL: Should not have attempted to commit"
    echo "Output: $output"
    exit 1
else
    echo "PASS: Did not attempt to commit"
end


echo "--- Test 3: git commit failure ---"
set -x FAIL_ON commit
set output (gacp "test message" 2>&1)
set status_code $status
set -e FAIL_ON

if test $status_code -eq 1
    echo "PASS: Status code 1 on git commit failure"
else
    echo "FAIL: Expected status 1, got $status_code"
    echo "Output: $output"
    exit 1
end

if string match -q "*Commit failed*" "$output"
    echo "PASS: Output contains failure message"
else
    echo "FAIL: Expected failure message, got '$output'"
    exit 1
end

if string match -q "*Pushing to remote*" "$output"
    echo "FAIL: Should not have attempted to push"
    echo "Output: $output"
    exit 1
else
    echo "PASS: Did not attempt to push"
end


echo "--- Test 4: Success ---"
set output (gacp "test message" 2>&1)
set status_code $status

if test $status_code -eq 0
    echo "PASS: Status code 0 on success"
else
    echo "FAIL: Expected status 0, got $status_code"
    echo "Output: $output"
    exit 1
end

if string match -q "*Done!*" "$output"
    echo "PASS: Output contains success message"
else
    echo "FAIL: Expected success message, got '$output'"
    exit 1
end

echo "✅ All gacp tests passed"
