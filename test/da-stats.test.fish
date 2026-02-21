# Mock functions to simulate system state
function hostname
    echo "test-host"
end

function df
    echo "Filesystem      Size  Used Avail Use% Mounted on"
    echo "/dev/root        50G   20G   27G  42% /"
end

function free
    echo "               total        used        free      shared  buff/cache   available"
    echo "Mem:           16000        8000        4000         100        4000        8000"
    echo "Swap:              0           0           0"
end

function uptime
    echo " 12:34:56 up 10 days,  1:23,  1 user,  load average: 0.25, 0.35, 0.45"
end

function tailscale
    if test "$argv[1]" = "ip"
        echo "100.100.100.100"
    end
end

# Source the function to test
source functions/da-stats.fish

set -l failed 0

# Test 1: Using optimized /proc/loadavg read
echo ":: Testing /proc/loadavg optimization"
set -g _da_stats_load_file (mktemp)
echo "0.15 0.25 0.35 1/123 12345" > $_da_stats_load_file

set output (da-stats)

if not string match -q "*CPU Load:*0.15*" $output
    echo "❌ /proc read failed. Output: $output"
    set failed 1
end

rm $_da_stats_load_file
set -e _da_stats_load_file

# Test 2: Fallback to uptime (by pointing to non-existent file)
echo ":: Testing uptime fallback"
set -g _da_stats_load_file "/non/existent/path"
# uptime mock returns 0.25
set output_fallback (da-stats)

if not string match -q "*CPU Load:*0.25*" $output_fallback
    echo "❌ Uptime fallback failed. Output: $output_fallback"
    set failed 1
end

set -e _da_stats_load_file

# Check other fields (from Test 1)
if not string match -q "*test-host*" $output
    echo "❌ Hostname missing"
    set failed 1
end

if not string match -q "*Disk Usage:*42%*" $output
    echo "❌ Disk usage incorrect"
    set failed 1
end

if not string match -q "*Memory:*50%*(8000/16000 MiB)*" $output
    echo "❌ Memory usage incorrect"
    set failed 1
end

if not string match -q "*Mesh IP:*100.100.100.100*" $output
    echo "❌ Mesh IP incorrect"
    set failed 1
end

if test $failed -eq 0
    echo "✅ da-stats.test.fish passed"
    exit 0
else
    echo "❌ da-stats.test.fish failed"
    exit 1
end
# Test for da-stats.fish

# Source the function
source functions/da-stats.fish

# Capture output
set -l output (da-stats)

# Check for header
if not string match -q "*SYSTEM INTEL*" $output
    echo "❌ Missing Header"
    exit 1
end

# Check for Disk Usage label
if not string match -q "*Disk Usage*" $output
    echo "❌ Missing Disk Usage label"
    exit 1
end

# Check for Memory label
if not string match -q "*Memory*" $output
    echo "❌ Missing Memory label"
    exit 1
end

# Check for CPU Load label
if not string match -q "*CPU Load*" $output
    echo "❌ Missing CPU Load label"
    exit 1
end

# Check for Mesh IP label
if not string match -q "*Mesh IP*" $output
    echo "❌ Missing Mesh IP label"
    exit 1
end

# Check for Status Summary (nominal OR recommended)
if not string match -q "*nominal*" $output
    if not string match -q "*recommended*" $output
        echo "❌ Missing Status Summary"
        exit 1
    end
end

# Check for bar characters (ensure at least one type of bar char is present)
# Note: output contains color codes and potentially newlines
# We check if the output contains either filled or empty bar segments
if not string match -q "*█*" $output
    if not string match -q "*░*" $output
        echo "❌ Missing progress bar characters (█ or ░)"
        exit 1
    end
end

# Check that helper function was cleaned up
if functions -q _da_print_bar
    echo "❌ Helper function _da_print_bar was not cleaned up"
    exit 1
end

echo "✅ da-stats.fish PASSED"
