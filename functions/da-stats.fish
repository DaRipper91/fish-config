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
    # Optimization: Use df -hP (POSIX) to ensure single line, read directly to avoid awk/tail
    set -l disk_p ""
    if type -q df
        df -hP / | string match -v 'Filesystem*' | read -l -a disk_data
        # disk_data[5] is Use% (e.g. "40%")
        set disk_p (string replace '%' '' $disk_data[5])
    end

    set -l color_disk green
    if test -n "$disk_p"
        if test "$disk_p" -ge 90
            set color_disk red
        else if test "$disk_p" -ge 70
            set color_disk yellow
        end
    else
        set disk_p "N/A"
        set color_disk red
    end
    echo -s (set_color -o) "💾 Disk Usage: " (set_color $color_disk) $disk_p% (set_color normal)

    # Memory Usage
    # Optimization: Parse `free -m` once using string match/read instead of calling it twice + grep + awk
    set -l mem_used 0
    set -l mem_total 0
    if type -q free
        free -m | string match 'Mem:*' | read -l -a mem_data
        set mem_total $mem_data[2]
        set mem_used $mem_data[3]
    end

    set -l mem_p 0
    if test "$mem_total" -gt 0
        set mem_p (math -s0 "$mem_used / $mem_total * 100")
    end

    set -l color_mem green
    if test "$mem_p" -ge 90
        set color_mem red
    else if test "$mem_p" -ge 70
        set color_mem yellow
    end
    echo -s (set_color -o) "🧠 Memory:     " (set_color $color_mem) $mem_p% (set_color normal) " ($mem_used/$mem_total MiB)"

    # CPU Load
    # Optimization: Read /proc/loadavg directly if available, fallback to optimized uptime parsing
    set -l load ""
    set -q _da_stats_load_file; or set -l _da_stats_load_file /proc/loadavg

    if test -r $_da_stats_load_file
        read -l load_line < $_da_stats_load_file
        # /proc/loadavg format: 0.00 0.01 0.05 1/123 12345
        string split " " $load_line | read -l load_val rest
        set load $load_val
    else if type -q uptime
        set -l matches (uptime | string match -r 'load average: (.*)')
        # matches[2] contains the capture group "0.15, 0.25, 0.35"
        if test (count $matches) -ge 2
            string split "," $matches[2] | read -l load_val rest
            set load (string trim $load_val)
        end
    end

    set -l color_cpu green
    if test -n "$load"
        # Use math to compare float load directly to thresholds, avoiding truncation from -s0 scaling
        # Load thresholds: 2.0 and 4.0
        if test (math "$load > 4.0") -eq 1
            set color_cpu red
        else if test (math "$load > 2.0") -eq 1
            set color_cpu yellow
        end
    else
        set load "N/A"
        set color_cpu red
    end
    echo -s (set_color -o) "🌡️  CPU Load:   " (set_color $color_cpu) $load (set_color normal)
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
