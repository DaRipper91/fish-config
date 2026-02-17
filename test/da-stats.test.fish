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
