function fish_prompt
    set -l last_status $status
    # Optimization: Use internal variable instead of external tput, with fallback
    set -l term_width $COLUMNS
    test -z "$term_width"; and set term_width (tput cols)

    # -----------------------------------------------------------------
    # 1. THE CHAOS ENGINE (Added Case 5: HOLO-FLUX)
    # -----------------------------------------------------------------
    set -l dice (random 1 5)
    set -l c_main_bg; set -l c_main_fg
    set -l c_sec_bg; set -l c_sec_fg
    set -l theme_name

    switch $dice
        case 1 # CRIMSON
            set c_main_bg 500000; set c_main_fg FF0000
            set c_sec_bg 330000; set c_sec_fg FFFFFF
            set theme_name "CRIMSON"
        case 2 # VOID
            set c_main_bg 2E003E; set c_main_fg 00F0FF
            set c_sec_bg 100C1F; set c_sec_fg E0E0E0
            set theme_name "VOID"
        case 3 # FORGED
            set c_main_bg FF4500; set c_main_fg 111111
            set c_sec_bg 552200; set c_sec_fg FFD700
            set theme_name "FORGED"
        case 4 # PRISM
            set c_main_bg FF00CC; set c_main_fg FFFFFF
            set c_sec_bg 550044; set c_sec_fg 00F0FF
            set theme_name "PRISM"
        case 5 # HOLO-FLUX (New: Extracted from your images)
            set c_main_bg 008080; set c_main_fg FF00FF # Teal & Hot Pink
            set c_sec_bg 1A0033; set c_sec_fg 00FFCC # Deep Sparkle & Cyan
            set theme_name "HOLO"
    end

    # -----------------------------------------------------------------
    # 2. DATA GATHERING
    # -----------------------------------------------------------------

    # [CPU] Load
    # Optimization: Read directly to avoid cat/cut forks
    read -l -a load_avg < /proc/loadavg
    set -l cpu_load $load_avg[1]
    set -l cpu_display "  $cpu_load "

    # [RAM] Used
    # Optimization: Read file once, use string match instead of grep/awk
    read -z mem_info < /proc/meminfo
    set -l mem_total (string match -r "MemTotal:\s+(\d+)" $mem_info)[2]
    set -l mem_free (string match -r "MemAvailable:\s+(\d+)" $mem_info)[2]
    set -l mem_used_mb (math "($mem_total - $mem_free) / 1024")
    set -l ram_display "  "(string replace -r '\..*' '' $mem_used_mb)"M "

    # [DISK] Free
    # Optimization: Cache df result for 60s to avoid forking on every prompt
    if not set -q _fish_prompt_disk_ts
        set -g _fish_prompt_disk_ts 0
        set -g _fish_prompt_disk_cache ""
    end

    set -l current_ts (date +%s)
    if test (math "$current_ts - $_fish_prompt_disk_ts") -gt 60
        set -g _fish_prompt_disk_cache (df -hP / | begin; read -l _; read -l line; echo $line; end | string split -n " ")[4]
        set -g _fish_prompt_disk_ts $current_ts
    end
    set -l disk_avail $_fish_prompt_disk_cache
    set -l disk_display "  "$disk_avail" "

    # [NET] Interface + IP
    # Optimization: Read /proc/net/route directly to avoid external process fork (ip)
    set -l net_display "  Offline "
    set -l icon ""

    if test -r /proc/net/route
        read -z route_data < /proc/net/route
        # Match lines starting with iface followed by destination 00000000
        # Use \n to anchor to start of line to avoid partial matches on other columns
        set -l match (string match -r '\n(\S+)\s+00000000' $route_data)

        if test (count $match) -ge 2
            set -l iface $match[2]
            if string match -q "wlan*" $iface
                set icon ""
            else
                set icon ""
            end
            set net_display " $icon $iface "
    # Optimization: Read /proc/net/route directly to avoid 'ip' command fork & DNS lookup
    set -l net_display "  Offline "
    set -l icon ""
    set -l iface ""

    if test -r /proc/net/route
        while read -l line
            set -l parts (string match -r -a '\S+' -- $line)
            # 2nd field is Destination. 00000000 is default gateway.
            if test "$parts[2]" = "00000000"
                set iface $parts[1]
                break
            end
        end < /proc/net/route
    end

    if test -n "$iface"
        if string match -q "wlan*" $iface
            set icon ""
        else
            set icon ""
        end
    end

    # [TIME]
    set -l time_display "  "(date '+%H:%M:%S')" "

    # -----------------------------------------------------------------
    # 3. RENDER TOP LINE (The Dashboard)
    # -----------------------------------------------------------------

    # --- LEFT SIDE (Identity + Path) ---
    # Calc length without color codes
    set -l left_text "$theme_name  "(prompt_pwd)" "
    set -l left_len (string length "$theme_name  "(prompt_pwd)" ")

    # --- RIGHT SIDE (The Stack) ---
    # We build the segments visually to calculate total length
    set -l right_len (string length "$cpu_display$ram_display$disk_display$net_display$time_display")

    # --- RENDER LEFT ---
    set_color -b $c_main_bg $c_main_fg --bold
    echo -n " $theme_name "
    set_color -b $c_sec_bg $c_main_bg
    echo -n ""
    set_color -b $c_sec_bg $c_sec_fg normal
    echo -n " "(prompt_pwd)" "
    set_color normal

    # --- FILLER ---
    set -l filler_len (math "$term_width - ($left_len + $right_len)")
    if test $filler_len -gt 0
        string repeat -n $filler_len " "

        # --- RENDER RIGHT (Reverse Powerline) ---
        # 1. CPU (Secondary)
        set_color -b $c_sec_bg $c_sec_fg
        echo -n "$cpu_display"

        # 2. RAM (Main)
        set_color -b $c_main_bg $c_sec_bg
        echo -n ""
        set_color -b $c_main_bg $c_main_fg
        echo -n "$ram_display"

        # 3. DISK (Secondary)
        set_color -b $c_sec_bg $c_main_bg
        echo -n ""
        set_color -b $c_sec_bg $c_sec_fg
        echo -n "$disk_display"

        # 4. NET (Main)
        set_color -b $c_main_bg $c_sec_bg
        echo -n ""
        set_color -b $c_main_bg $c_main_fg
        echo -n "$net_display"

        # 5. TIME (Dark Anchor)
        set_color -b 101010 $c_main_bg
        echo -n ""
        set_color -b 101010 FFFFFF --bold
        echo -n "$time_display"
        set_color normal
    end

    echo # New Line

    # -----------------------------------------------------------------
    # 4. RENDER BOTTOM LINE (The Gutter)
    # -----------------------------------------------------------------
    set_color $c_main_bg
    echo -n "╰─"

    if test $last_status -ne 0
        set_color FF0000
    else
        set_color $c_sec_fg
    end

    echo -n " "
    set_color normal
end
