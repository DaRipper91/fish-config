function da-stats --description "Mesh Resource Intel"
    # Header
    echo -s (set_color -o blue) "📊 SYSTEM INTEL: " (set_color green) (hostname) (set_color normal)
    echo -s (set_color brblack) "---" (set_color normal)

    # Disk Usage
    set -l disk_p (df -h / | tail -1 | awk '{print $5}' | string replace '%' '')
    set -l color_disk green
    if test "$disk_p" -ge 90
        set color_disk red
    else if test "$disk_p" -ge 70
        set color_disk yellow
    end
    echo -s (set_color -o) "💾 Disk Usage: " (set_color $color_disk) $disk_p% (set_color normal)

    # Memory Usage
    set -l mem_used (free -m | grep Mem | awk '{print $3}')
    set -l mem_total (free -m | grep Mem | awk '{print $2}')
    set -l mem_p (math -s0 "$mem_used / $mem_total * 100")
    set -l color_mem green
    if test "$mem_p" -ge 90
        set color_mem red
    else if test "$mem_p" -ge 70
        set color_mem yellow
    end
    echo -s (set_color -o) "🧠 Memory:     " (set_color $color_mem) $mem_p% (set_color normal) " ($mem_used/$mem_total MiB)"

    # CPU Load
    set -l load (uptime | awk -F'load average:' '{ print $2 }' | string split ',' | head -n1 | string trim)
    set -l color_cpu green
    # Use awk for float comparison
    if awk "BEGIN {exit !($load > 4.0)}"
        set color_cpu red
    else if awk "BEGIN {exit !($load > 2.0)}"
        set color_cpu yellow
    end
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
