function da-stats --description "Mesh Resource Intel"
    # Helper for progress bars and alignment
    function _da_print_bar
        set -l label $argv[1]
        set -l p $argv[2]
        set -l text $argv[3]

        # Handle cases where p is empty or invalid
        if test -z "$p"
            set p 0
        end

        # Color logic
        set -l color green
        if test $p -ge 90
            set color red
        else if test $p -ge 70
            set color yellow
        end

        # Bar drawing logic
        set -l filled (math -s0 "round($p / 10)")
        # Clamp values between 0 and 10
        if test $filled -gt 10
            set filled 10
        end
        if test $filled -lt 0
            set filled 0
        end

        set -l empty (math "10 - $filled")

        # Print aligned label
        printf "%s%-15s%s" (set_color -o) "$label" (set_color normal)

        # Print bar
        printf "%s[" (set_color $color)
        if test $filled -gt 0
            string repeat -n $filled "█"
        end
        if test $empty -gt 0
            string repeat -n $empty "░"
        end
        printf "] %3d%%%s" $p (set_color normal)

        # Print extra text if available
        if test -n "$text"
            printf " %s" "$text"
        end
        echo
    end

    # Header
    echo -s (set_color -o blue) "📊 SYSTEM INTEL: " (set_color green) (hostname) (set_color normal)
    echo -s (set_color brblack) "----------------------------------------" (set_color normal)

    # Disk Usage
    set -l df_out (df -hP /)
    set -l disk_p (string split " " --no-empty $df_out[-1])[5]
    set disk_p (string replace '%' '' $disk_p)
    _da_print_bar "💾 Disk Usage" $disk_p

    # Memory Usage
    set -l free_out (free -m)
    set -l mem_data (string match -r "Mem:\s+(\d+)\s+(\d+)" $free_out)
    set -l mem_total $mem_data[2]
    set -l mem_used $mem_data[3]
    set -l mem_p (math -s0 "$mem_used / $mem_total * 100")
    _da_print_bar "🧠 Memory" $mem_p "($mem_used/$mem_total MiB)"

    # CPU Load
    set -l cores (nproc 2>/dev/null; or echo 1)
    set -l load_match (uptime | string match -r "load average: ([0-9.]+)")
    set -l load $load_match[2]
    set -l cpu_p (math -s0 "round($load * 100 / $cores)")
    # Clamp purely for display logic in bar, but keep real %
    # Pass real percentage to helper
    _da_print_bar "🌡️  CPU Load" $cpu_p "($load load / $cores cores)"

    # Mesh IP
    set -l ip ""
    if type -q tailscale
        set ip (tailscale ip -4 2>/dev/null)
    end

    set -l color_ip cyan
    if test -z "$ip"
        set ip Offline
        set color_ip red
    end
    printf "%s%-15s%s" (set_color -o) "🌐 Mesh IP" (set_color normal)
    printf "%s%s%s\n" (set_color $color_ip) "$ip" (set_color normal)

    echo -s (set_color brblack) "----------------------------------------" (set_color normal)

    # Status Summary
    set -l status_ok true
    if test "$disk_p" -ge 90; or test "$mem_p" -ge 90; or test "$cpu_p" -ge 90; or test "$ip" = "Offline"
        set status_ok false
    end

    if test "$status_ok" = true
        echo (set_color green)"✅ All systems nominal."(set_color normal)
    else
        echo (set_color yellow)"⚠️  System check recommended."(set_color normal)
    end

    # Cleanup helper
    functions -e _da_print_bar
end
