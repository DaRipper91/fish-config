function da-stats --description "Mesh Resource Intel"
    # Header
    echo -s (set_color -o blue) "📊 SYSTEM INTEL: " (set_color green) (hostname) (set_color normal)
    echo -s (set_color brblack) "---" (set_color normal)

    # Disk Usage
    # Optimization: Use df -hP and string manipulation to avoid tail/awk
    set -l df_out (df -hP /)
    # The 5th column in POSIX df output is Use%
    set -l disk_p (string split " " --no-empty $df_out[-1])[5]
    set disk_p (string replace '%' '' $disk_p)

    set -l color_disk green
    if test "$disk_p" -ge 90
        set color_disk red
    else if test "$disk_p" -ge 70
        set color_disk yellow
    end
    echo -s (set_color -o) "💾 Disk Usage: " (set_color $color_disk) $disk_p% (set_color normal)

    # Memory Usage
    # Optimization: Call free once and parse with string match (replaces 2x free, 2x grep, 2x awk)
    set -l free_out (free -m)
    set -l mem_data (string match -r "Mem:\s+(\d+)\s+(\d+)" $free_out)
    set -l mem_total $mem_data[2]
    set -l mem_used $mem_data[3]

    set -l mem_p (math -s0 "$mem_used / $mem_total * 100")
    set -l color_mem green
    if test "$mem_p" -ge 90
        set color_mem red
    else if test "$mem_p" -ge 70
        set color_mem yellow
    end
    echo -s (set_color -o) "🧠 Memory:     " (set_color $color_mem) $mem_p% (set_color normal) " ($mem_used/$mem_total MiB)"

    # CPU Load
    # Optimization: Use string match for load average and single awk call for comparison
    set -l load_match (uptime | string match -r "load average: ([0-9.]+)")
    set -l load $load_match[2]

    # Combine color logic into single awk call (replaces 2x awk)
    set -l color_cpu (awk -v load="$load" 'BEGIN { if (load > 4.0) print "red"; else if (load > 2.0) print "yellow"; else print "green" }')
    echo -s (set_color -o) "🌡️  CPU Load:   " (set_color $color_cpu) $load (set_color normal)

    # Mesh IP
    set -l ip ""
    if type -q tailscale
        set ip (tailscale ip -4 2>/dev/null)
    end

    set -l color_ip cyan
    if test -z "$ip"
        set ip "Offline"
        set color_ip red
    end
    echo -s (set_color -o) "🌐 Mesh IP:    " (set_color $color_ip) $ip (set_color normal)
end
