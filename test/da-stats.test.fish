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
