function dap --description 'DA-PACAGER: The Pastel Pacman Architect (Gold Master)'

    # -- [1] GLOBAL THEME INITIALIZATION --
    function __pkg_init_theme
        set -g c_pink   (set_color -o ffb3ba)
        set -g c_peach  (set_color -o ffdfba)
        set -g c_yellow (set_color -o ffffba)
        set -g c_mint   (set_color -o baffc9)
        set -g c_blue   (set_color -o bae1ff)
        set -g c_lav    (set_color -o eecbff)
        set -g c_white  (set_color ffffff)
        set -g c_gray   (set_color 999999)
        set -g c_dark   (set_color 333333)
        set -g c_rst    (set_color normal)

        set -g sym_pac   "ᗧ"
    end

    __pkg_init_theme

    # -- [2] HELPER: CENTERING ENGINE --
    function __pkg_center
        set -l str "$argv"
        # Strip ANSI codes to get visual length
        set -l plain_str (echo -e "$str" | sed 's/\x1b\[[0-9;]*m//g')
        set -l str_len (string length "$plain_str")
        set -l term_width (tput cols)
        set -l padding (math -s0 "($term_width - $str_len) / 2")

        if test $padding -gt 0
            printf "%"(echo $padding)"s%s\n" "" "$str"
        else
            printf "%s\n" "$str"
        end
    end

    # -- [3] INTERNAL UI FUNCTIONS --

    function __pkg_startup_anim
        tput civis
        echo ""
        set -l dots "• • • • • • • • • •"
        for i in (seq 0 10)
            set -l eaten (string repeat -n $i " ")
            set -l uneaten (string sub -s (math $i + 1) "$dots")
            set -l line "$c_lav[LOAD] $c_yellow$sym_pac $eaten$c_rst$uneaten $c_lav(System waking...)$c_rst"
            # Centering the loader
            set -l plain_line (echo -e "$line" | sed 's/\x1b\[[0-9;]*m//g')
            set -l padding (math -s0 "((tput cols) - (string length \"$plain_line\")) / 2")
            printf "\r%s%s" (string repeat -n $padding " ") "$line"
            sleep 0.08
        end
        echo -e "\n"
        tput cnorm
    end

    function __pkg_draw_header
        clear
        set -l pkg_count (pacman -Qq | count)
        set -l cpu_temp (sensors 2>/dev/null | grep "Package id 0" | awk '{print $4}' | sed 's/+//')
        set -l ram_use (free -h | grep "Mem:" | awk '{print $3 "/" $2}')
        set -l swap_use (free -h | grep "Swap:" | awk '{print $3}')

        __pkg_center "$c_blue┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓$c_rst"
        __pkg_center "$c_pink   ____    _      $c_peach ____   _      $c_mint  ____    _    $c_blue  ____  _____ ____  $c_rst"
        __pkg_center "$c_pink  |  _ \  / \     $c_peach|  _ \ / \     $c_mint / ___|  / \   $c_blue / ___|| ____|  _ \ $c_rst"
        __pkg_center "$c_pink  | | | |/ _ \    $c_peach| |_) / _ \    $c_mint| |     / _ \  $c_blue| |  _ |  _| | |_) |$c_rst"
        __pkg_center "$c_pink  | |_| / ___ \   $c_peach|  __/ ___ \   $c_mint| |___ / ___ \ $c_blue| |_| || |___|  _ < $c_rst"
        __pkg_center "$c_pink  |____/_/   \_\  $c_peach|_| /_/   \_\  $c_mint \____/_/   \_\ $c_blue\____||_____|_| \_\ $c_rst"
        echo ""
        __pkg_center "$c_gray TEMP: $c_pink$cpu_temp   $c_gray RAM: $c_mint$ram_use   $c_gray SWAP: $c_lav$swap_use   $c_gray PKGS: $c_white$pkg_count$c_rst"
        __pkg_center "$c_blue┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛$c_rst"
    end

    # -- [4] MAIN LOOP --
    __pkg_startup_anim

    while true
        __pkg_draw_header

        set -l kernel (uname -r)
        set -l uptime_val (uptime -p | sed 's/up //')
        set -l birth_date (expac -Q '%l' filesystem | head -n1; or echo "Unknown")

        __pkg_center "$c_gray  Kernel: $c_white$kernel     $c_gray  Uptime: $c_white$uptime_val     $c_gray 🎂 Born: $c_white$birth_date $c_rst"
        echo ""

        # Dashboard Grid
        __pkg_center "$c_lav╭── $c_pink PACKAGE OPERATIONS$c_lav ───────────╮  ╭── $c_blue SYSTEM TOOLS$c_lav ───────────────╮$c_rst"
        __pkg_center "│                               │  │                               │"
        __pkg_center "│  $c_mint [1] $c_white Search & Install      $c_lav │  │  $c_mint [7] $c_white Clear Cache            $c_lav │"
        __pkg_center "│  $c_peach [2] $c_white Remove Package         $c_lav │  │  $c_peach [8] $c_white Backup Configs         $c_lav │"
        __pkg_center "│  $c_blue [3] $c_white System Update          $c_lav │  │  $c_blue [9] $c_white Edit Configs           $c_lav │"
        __pkg_center "│  $c_mint [4] $c_white Clean Orphans          $c_lav │  │  $c_mint [10] $c_white List Installed         $c_lav │"
        __pkg_center "│  $c_peach [5] $c_white Unlock Database        $c_lav │  │  $c_peach [11] $c_white Arch News Feed         $c_lav │"
        __pkg_center "│  $c_blue [6] $c_white Package Info           $c_lav │  │  $c_blue [12] $c_white Dependency Tree        $c_lav │"
        __pkg_center "│                               │  │  $c_mint [13] $c_white Cheat Sheet Search     $c_lav │"
        __pkg_center "╰───────────────────────────────╯  ╰──────────────────────────────╯"

        echo ""
        __pkg_center "$c_gray [q] Exit Session $c_rst"
        echo ""

        # Centering the prompt itself
        set -l prompt_text "   Select Action :: "
        set -l prompt_len (string length "$prompt_text")
        set -l prompt_pad (math -s0 "((tput cols) - 70) / 2") # Adjusted for the dash box width

        read -P (string repeat -n $prompt_pad " ")"Select Action :: " choice

        switch $choice
            case 1
                # ... [Keep previous case logic, just ensure you call __pkg_draw_header]
            case q Q
                clear
                return 0
        end
    end
end
