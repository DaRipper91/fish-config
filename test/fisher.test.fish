source functions/fisher.fish

set -l cmd "nonsense"
set -l output (fisher $cmd 2>&1)
set -l status_code $status

if test "$output" = "fisher: Unknown command: \"$cmd\""
    echo "PASS: Output matches expected error message"
else
    echo "FAIL: Expected 'fisher: Unknown command: \"$cmd\"', got '$output'"
    exit 1
end

if test $status_code -eq 1
    echo "PASS: Exit status is 1"
else
    echo "FAIL: Expected exit status 1, got $status_code"
    exit 1
end
