# test/gacp.test.fish

# Mock git function
function git
    set cmd $argv[1]

    # Simulate failures based on global variables
    if test "$cmd" = "add"
        if set -q FAIL_ADD
            return 1
        end
    end

    if test "$cmd" = "commit"
        if set -q FAIL_COMMIT
            return 1
        end
        # Verify message argument is passed
        if test (count $argv) -lt 3; or test "$argv[2]" != "-m"
             echo "MOCK ERROR: Commit missing -m flag"
             return 1
        end
    end

    if test "$cmd" = "push"
        if set -q FAIL_PUSH
            return 1
        end
    end

    return 0
end

# Load the function to test
source functions/gacp.fish

echo "🧪 Testing gacp..."

# Test 1: No args
echo ":: Test 1: No args (should fail)"
if gacp
    echo "❌ FAIL: succeeded with no args"
    exit 1
else
    echo "✅ PASS: failed as expected"
end

# Test 2: Success path
echo ":: Test 2: Success path"
if gacp "test message"
    echo "✅ PASS: success path works"
else
    echo "❌ FAIL: success path failed"
    exit 1
end

# Test 3: Add failure
echo ":: Test 3: git add failure"
set -g FAIL_ADD 1
if gacp "test message"
    echo "❌ FAIL: succeeded despite add failure"
    exit 1
else
    echo "✅ PASS: failed on add"
end
set -e FAIL_ADD

# Test 4: Commit failure
echo ":: Test 4: git commit failure"
set -g FAIL_COMMIT 1
if gacp "test message"
    echo "❌ FAIL: succeeded despite commit failure"
    exit 1
else
    echo "✅ PASS: failed on commit"
end
set -e FAIL_COMMIT

# Test 5: Push failure
echo ":: Test 5: git push failure"
set -g FAIL_PUSH 1
if gacp "test message"
    echo "❌ FAIL: succeeded despite push failure"
    exit 1
else
    echo "✅ PASS: failed on push"
end
set -e FAIL_PUSH

exit 0
