# Mock external commands for testing da-stats optimization

# Mock df
function df
    echo "Filesystem      Size  Used Avail Use% Mounted on"
    echo "/dev/root        20G   10G   10G  50% /"
end

# Mock free
function free
    echo "              total        used        free      shared  buff/cache   available"
    echo "Mem:           8000        2000        6000           0           0        6000"
    echo "Swap:             0           0           0"
end

# Mock uptime
function uptime
    echo " 14:26:53 up 2 days,  4:06,  1 user,  load average: 1.05, 0.04, 0.05"
end

# Mock tailscale
function tailscale
    echo "1.2.3.4"
end

# Mock set_color (no-op)
function set_color
end

# Source the function to test
source functions/da-stats.fish

echo "🧪 Running da-stats test..."

# Capture output
set output (da-stats | string collect)

# Assertions
set failed 0

# Disk Usage: Expect 50%
# Check for double percentage (bug regression)
if string match -q "*Disk Usage: *50%%*" $output
    echo "❌ Disk Usage Check Failed: Output has double percentage (bug regression)."
    echo "Output: $output"
    set failed 1
else if string match -q "*Disk Usage: *50%*" $output
    echo "✅ Disk Usage Check Passed"
else
    echo "❌ Disk Usage Check Failed. Output was:"
    echo $output
    set failed 1
end

# Memory Usage: 2000/8000 = 25%
if string match -q "*Memory:      25%*" $output
    echo "✅ Memory Usage Check Passed"
else
    echo "❌ Memory Usage Check Failed. Output was:"
    echo $output
    set failed 1
end

# CPU Load: Expect 1.05
if string match -q "*CPU Load:    1.05*" $output
    echo "✅ CPU Load Check Passed"
else
    echo "❌ CPU Load Check Failed. Output was:"
    echo $output
    set failed 1
end

# Mesh IP: Expect 1.2.3.4
if string match -q "*Mesh IP:     1.2.3.4*" $output
    echo "✅ Mesh IP Check Passed"
else
    echo "❌ Mesh IP Check Failed. Output was:"
    echo $output
    set failed 1
end

if test $failed -eq 1
    exit 1
else
    echo "🎉 All da-stats tests passed!"
    exit 0
end
