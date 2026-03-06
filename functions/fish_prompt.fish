function fish_prompt
    set -l last_status $status

    # -----------------------------------------------------------------
    # 0. OPTIMIZATIONS (Avoid process forks for prompt speed)
    # -----------------------------------------------------------------
    # Use $COLUMNS for terminal width (builtin)
    set -l term_width $COLUMNS
    if test -z "$term_width"
        set term_width (tput cols)
    end

    # -----------------------------------------------------------------
    # 1. THE CHAOS ENGINE (Visual Identity)
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
        case 5 # HOLO-FLUX
            set c_main_bg 008080; set c_main_fg FF00FF # Teal & Hot Pink
            set c_sec_bg 1A0033; set c_sec_fg 00FFCC # Deep Sparkle & Cyan
            set theme_name "HOLO"
    end

    # -----------------------------------------------------------------
    # 2. DATA GATHERING
    # -----------------------------------------------------------------

    # [CPU] Load - Read directly from /proc/loadavg (builtin)
    if test -r /proc/loadavg
        read -l -d ' ' cpu_load _ < /proc/loadavg
    else
        set cpu_load "?.??"
    end
    set -l cpu_display "  $cpu_load "

    # [RAM] Used - Read directly from /proc/meminfo (builtin)
    set -l ram_display "  ??M "
    if test -r /proc/meminfo
        read -z mem_info < /proc/meminfo
        set -l mem_total (string match -r 'MemTotal:\s+(\d+)' $mem_info)[2]
        set -l mem_free (string match -r 'MemAvailable:\s+(\d+)' $mem_info)[2]
        if test -n "$mem_total" -a -n "$mem_free"
            set -l mem_used_mb (math "($mem_total - $mem_free) / 1024")
            set ram_display "  "(string replace -r '\..*' '' $mem_used_mb)"M "
        end
    end

    # [DISK] Free - Cache df result for 60s
    if not set -q _fish_prompt_disk_ts
        set -g _fish_prompt_disk_ts 0
        set -g _fish_prompt_disk_cache ""
    end

    set -l current_ts (date +%s)
    if test (math "$current_ts - $_fish_prompt_disk_ts") -gt 60
        # Optimization: Use -P for portability and split string (avoids awk)
        set -l df_out (df -hP / 2>/dev/null)
        if test $status -eq 0
            set -g _fish_prompt_disk_cache (string split -n " " $df_out[2])[4]
            set -g _fish_prompt_disk_ts $current_ts
        end
    end
    set -l disk_avail $_fish_prompt_disk_cache
    if test -z "$disk_avail"
        set disk_avail "??G"
    end
    set -l disk_display "  $disk_avail "

    # [NET] Interface - Read /proc/net/route directly
    set -l net_display "  Offline "
    set -l icon ""
    if test -r /proc/net/route
        read -z route_data < /proc/net/route
        # Match lines starting with iface followed by destination 00000000 (default gateway)
        set -l match (string match -r '\n(\S+)\s+00000000' $route_data)
        if test (count $match) -ge 2
            set -l iface $match[2]
            if string match -q "wlan*" $iface
                set icon ""
            else
                set icon ""
            end
            set net_display " $icon $iface "
        end
    end

    # [TIME]
    set -l time_display "  "(date '+%H:%M:%S')" "

    # -----------------------------------------------------------------
    # 3. RENDER TOP LINE (The Dashboard)
    # -----------------------------------------------------------------

    # --- LEFT SIDE (Identity + Path) ---
    set -l left_text "$theme_name  "(prompt_pwd)" "
    set -l left_len (string length "$left_text")

    # --- RIGHT SIDE (The Stack) ---
    set -l right_text "$cpu_display$ram_display$disk_display$net_display$time_display"
    set -l right_len (string length "$right_text")

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
    end

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
