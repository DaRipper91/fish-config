function da-stats --description "Mesh Resource Intel"
    # Header
    # Optimization: Use $hostname variable instead of command
    echo -s (set_color -o blue) "📊 SYSTEM INTEL: " (set_color green) $hostname (set_color normal)
    echo -s (set_color brblack) "---" (set_color normal)

    # Disk Usage
    # Optimization: Use df -hP and string parsing instead of tail|awk
    # df -hP / outputs standard posix format, 5th column is percentage
    set -l df_out (df -hP / | tail -n 1)
    # Split by whitespace, get 5th element
    set -l disk_p (string replace '%' '' (string split -n " " $df_out)[5])

    set -l color_disk green
    if test "$disk_p" -ge 90
        set color_disk red
    else if test "$disk_p" -ge 70
        set color_disk yellow
    end
    echo -s (set_color -o) "💾 Disk Usage: " (set_color $color_disk) $disk_p% (set_color normal)

    # Memory Usage
    # Optimization: Call free once and parse with string split
    set -l mem_out (free -m | string match -r '^Mem:.*')
    set -l mem_vals (string split -n " " $mem_out)
    set -l mem_total $mem_vals[2]
    set -l mem_used $mem_vals[3]

    set -l mem_p (math -s0 "$mem_used / $mem_total * 100")
    set -l color_mem green
    if test "$mem_p" -ge 90
        set color_mem red
    else if test "$mem_p" -ge 70
        set color_mem yellow
    end
    echo -s (set_color -o) "🧠 Memory:     " (set_color $color_mem) $mem_p% (set_color normal) " ($mem_used/$mem_total MiB)"

    # CPU Load
    # Optimization: Parse uptime output with string match instead of awk/split/head
    set -l uptime_out (uptime)
    set -l load_str (string match -r 'load average: (.*)' $uptime_out)[2]
    set -l load (string split -m1 ',' $load_str)[1]
    set load (string trim $load)

    # Optimization: Integer math for load check (avoid awk spawn)
    # Get integer part of load (e.g. 4.05 -> 4)
    set -l load_int (string split -m1 . (string replace , . $load))[1]

    set -l color_cpu green
    if test "$load_int" -ge 4
        set color_cpu red
    else if test "$load_int" -ge 2
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
