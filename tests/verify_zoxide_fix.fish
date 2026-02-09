#!/usr/bin/env fish
# This test verifies that conf.d/zoxide.fish does not fail when sourced in a non-interactive shell,
# even if zoxide is missing. This ensures the guard `status is-interactive && type -q zoxide` is working.

echo "Testing conf.d/zoxide.fish guard..."
source conf.d/zoxide.fish

if test $status -eq 0
    echo "SUCCESS: zoxide initialization handled gracefully."
    exit 0
else
    echo "ERROR: zoxide initialization failed!"
    exit 1
end
