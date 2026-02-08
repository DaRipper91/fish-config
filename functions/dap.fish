function dap --description 'DA-PACAGER: The Pastel Pacman Architect (Gold Master)'

    # -- [1] THEME INITIALIZATION --
    # Using global variables with _dap_ prefix to avoid pollution and allow sharing with helper functions
    # They are cleaned up on exit.
    set -g _dap_c_pink   (set_color -o ffb3ba)
    set -g _dap_c_peach  (set_color -o ffdfba)
    set -g _dap_c_yellow (set_color -o ffffba)
    set -g _dap_c_mint   (set_color -o baffc9)
    set -g _dap_c_blue   (set_color -o bae1ff)
    set -g _dap_c_lav    (set_color -o eecbff)
    set -g _dap_c_white  (set_color ffffff)
    set -g _dap_c_gray   (set_color 999999)
    set -g _dap_c_dark   (set_color 333333)
    set -g _dap_c_rst    (set_color normal)

    set -g _dap_sym_pac   "ᗧ"

    function _dap_cleanup
        set -e _dap_c_pink _dap_c_peach _dap_c_yellow _dap_c_mint _dap_c_blue _dap_c_lav _dap_c_white _dap_c_gray _dap_c_dark _dap_c_rst _dap_sym_pac
        functions -e __pkg_center __pkg_startup_anim __pkg_draw_header _dap_cleanup
    end

    # -- [2] HELPER: CENTERING ENGINE --
    function __pkg_center
        set -l str "$argv"
        # Strip ANSI codes to get visual length
        set -l plain_str (echo -e "$str" | sed 's/\x1b\[[0-9;]*m//g')
        set -l str_len (string length "$plain_str")
        if type -q tput
            set term_width (tput cols)
        else
            set term_width 80
        end
        set -l padding (math -s0 "($term_width - $str_len) / 2")

        if test $padding -gt 0
            set -l pad_str (string repeat -n $padding " ")
            echo "$pad_str$str"
        else
            echo "$str"
        end
    end

    # -- [3] INTERNAL UI FUNCTIONS --

    function __pkg_startup_anim
        if not type -q tput
            return
        end
        tput civis
        echo ""
        set -l dots "• • • • • • • • • •"
        for i in (seq 0 10)
            set -l eaten (string repeat -n $i " ")
            set -l uneaten (string sub -s (math $i + 1) "$dots")
            set -l line "$_dap_c_lav[LOAD] $_dap_c_yellow$_dap_sym_pac $eaten$_dap_c_rst$uneaten $_dap_c_lav(System waking...)$_dap_c_rst"

            # Centering the loader
            set -l plain_line (echo -e "$line" | sed 's/\x1b\[[0-9;]*m//g')
            set -l term_cols (tput cols)
            set -l padding (math -s0 "($term_cols - (string length \"$plain_line\")) / 2")
             if test $padding -gt 0
                printf "\r%s%s" (string repeat -n $padding " ") "$line"
             else
                printf "\r%s" "$line"
             end
            sleep 0.08
        end
        echo -e "\n"
        tput cnorm
    end

    function __pkg_draw_header
        clear
        set -l pkg_count "N/A"
        if type -q pacman
            set pkg_count (pacman -Qq | count)
        end

        set -l cpu_temp "N/A"
        if type -q sensors
            set cpu_temp (sensors 2>/dev/null | grep "Package id 0" | awk '{print $4}' | sed 's/+//')
        end

        set -l ram_use "N/A"
        if type -q free
            set ram_use (free -h | grep "Mem:" | awk '{print $3 "/" $2}')
        end

        set -l swap_use "N/A"
        if type -q free
            set swap_use (free -h | grep "Swap:" | awk '{print $3}')
        end

        __pkg_center "$_dap_c_blue┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓$_dap_c_rst"
        __pkg_center "$_dap_c_pink   ____    _      $_dap_c_peach ____   _      $_dap_c_mint  ____    _    $_dap_c_blue  ____  _____ ____  $_dap_c_rst"
        __pkg_center "$_dap_c_pink  |  _ \  / \     $_dap_c_peach|  _ \ / \     $_dap_c_mint / ___|  / \   $_dap_c_blue / ___|| ____|  _ \ $_dap_c_rst"
        __pkg_center "$_dap_c_pink  | | | |/ _ \    $_dap_c_peach| |_) / _ \    $_dap_c_mint| |     / _ \  $_dap_c_blue| |  _ |  _| | |_) |$_dap_c_rst"
        __pkg_center "$_dap_c_pink  | |_| / ___ \   $_dap_c_peach|  __/ ___ \   $_dap_c_mint| |___ / ___ \ $_dap_c_blue| |_| || |___|  _ < $_dap_c_rst"
        __pkg_center "$_dap_c_pink  |____/_/   \_\  $_dap_c_peach|_| /_/   \_\  $_dap_c_mint \____/_/   \_\ $_dap_c_blue\____||_____|_| \_\ $_dap_c_rst"
        echo ""
        __pkg_center "$_dap_c_gray TEMP: $_dap_c_pink$cpu_temp   $_dap_c_gray RAM: $_dap_c_mint$ram_use   $_dap_c_gray SWAP: $_dap_c_lav$swap_use   $_dap_c_gray PKGS: $_dap_c_white$pkg_count$_dap_c_rst"
        __pkg_center "$_dap_c_blue┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛$_dap_c_rst"
    end

    # -- [4] MAIN LOOP --
    __pkg_startup_anim

    while true
        __pkg_draw_header

        set -l kernel (uname -r)
        set -l uptime_val (uptime -p | sed 's/up //')
        set -l birth_date "Unknown"
        if type -q expac
            set birth_date (expac -Q '%l' filesystem | head -n1)
        end

        __pkg_center "$_dap_c_gray  Kernel: $_dap_c_white$kernel     $_dap_c_gray  Uptime: $_dap_c_white$uptime_val     $_dap_c_gray 🎂 Born: $_dap_c_white$birth_date $_dap_c_rst"
        echo ""

        # Dashboard Grid
        __pkg_center "$_dap_c_lav╭── $_dap_c_pink PACKAGE OPERATIONS$_dap_c_lav ───────────╮  ╭── $_dap_c_blue SYSTEM TOOLS$_dap_c_lav ───────────────╮$_dap_c_rst"
        __pkg_center "│                               │  │                               │"
        __pkg_center "│  $_dap_c_mint [1] $_dap_c_white Search & Install      $_dap_c_lav │  │  $_dap_c_mint [7] $_dap_c_white Clear Cache            $_dap_c_lav │"
        __pkg_center "│  $_dap_c_peach [2] $_dap_c_white Remove Package         $_dap_c_lav │  │  $_dap_c_peach [8] $_dap_c_white Backup Configs         $_dap_c_lav │"
        __pkg_center "│  $_dap_c_blue [3] $_dap_c_white System Update          $_dap_c_lav │  │  $_dap_c_blue [9] $_dap_c_white Edit Configs           $_dap_c_lav │"
        __pkg_center "│  $_dap_c_mint [4] $_dap_c_white Clean Orphans          $_dap_c_lav │  │  $_dap_c_mint [10] $_dap_c_white List Installed         $_dap_c_lav │"
        __pkg_center "│  $_dap_c_peach [5] $_dap_c_white Unlock Database        $_dap_c_lav │  │  $_dap_c_peach [11] $_dap_c_white Arch News Feed         $_dap_c_lav │"
        __pkg_center "│  $_dap_c_blue [6] $_dap_c_white Package Info           $_dap_c_lav │  │  $_dap_c_blue [12] $_dap_c_white Dependency Tree        $_dap_c_lav │"
        __pkg_center "│                               │  │  $_dap_c_mint [13] $_dap_c_white Cheat Sheet Search     $_dap_c_lav │"
        __pkg_center "╰───────────────────────────────╯  ╰──────────────────────────────╯"

        echo ""
        __pkg_center "$_dap_c_gray [q] Exit Session $_dap_c_rst"
        echo ""

        # Centering the prompt itself
        set -l prompt_text "   Select Action :: "
        if type -q tput
            set term_cols (tput cols)
        else
            set term_cols 80
        end
        set -l prompt_pad (math -s0 "($term_cols - 70) / 2") # Adjusted for the dash box width

        if test $prompt_pad -lt 0
            set prompt_pad 0
        end

        read -P (string repeat -n $prompt_pad " ")"Select Action :: " choice

        switch $choice
            case 1
                if type -q fzf
                    pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S
                else
                    echo "fzf not found. Please install fzf or enter package name manually:"
                    read -P "Package name: " pkg
                    if test -n "$pkg"
                        sudo pacman -S $pkg
                    end
                end
            case 2
                 if type -q fzf
                    pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns
                 else
                     echo "fzf not found. Enter package name to remove:"
                     read -P "Package name: " pkg
                     if test -n "$pkg"
                        sudo pacman -Rns $pkg
                     end
                 end
            case 3
                sudo pacman -Syu
            case 4
                set -l orphans (pacman -Qtdq)
                if test -n "$orphans"
                    sudo pacman -Rns $orphans
                else
                    echo "No orphans found."
                end
            case 5
                sudo rm /var/lib/pacman/db.lck
                echo "Database unlocked."
            case 6
                 echo "Enter package name:"
                 read -P "> " pkg
                 if test -n "$pkg"
                     pacman -Qi $pkg
                 end
            case 7
                sudo pacman -Sc
            case 8
                echo "Backing up ~/.config to ~/.config.bak..."
                cp -r ~/.config ~/.config.bak
                echo "Done."
            case 9
                set -l editor $EDITOR
                if test -z "$editor"
                    set editor nano
                end
                $editor ~/.config/fish/config.fish
            case 10
                pacman -Q | less
            case 11
                if type -q curl
                    curl -s https://archlinux.org/feeds/news/ | grep -E '<title>|<pubDate>' | sed 's/<[^>]*>//g' | head -n 10
                else
                    echo "curl not found."
                end
            case 12
                if type -q pactree
                    echo "Enter package name:"
                    read -P "> " pkg
                    if test -n "$pkg"
                        pactree $pkg | less
                    end
                else
                    echo "pactree (pacman-contrib) not found."
                end
            case 13
                if type -q curl
                    echo "Enter cheat sheet query (e.g. python/list):"
                    read -P "> " query
                    curl cht.sh/$query | less -R
                else
                    echo "curl not found."
                end
            case q Q
                clear
                _dap_cleanup
                return 0
            case '*'
                echo "Invalid selection"
        end

        echo ""
        read -P "Press Enter to continue..." dummy
    end
    _dap_cleanup
end
