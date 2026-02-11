function dap --description 'DA-PACAGER: Senior Developer & Shop Partner Edition v2.0'
    # -- [1] THEME INITIALIZATION --
    set -g _dap_c_pink    (set_color -o ffb3ba)
    set -g _dap_c_peach   (set_color -o ffdfba)
    set -g _dap_c_yellow  (set_color -o ffffba)
    set -g _dap_c_mint    (set_color -o baffc9)
    set -g _dap_c_blue    (set_color -o bae1ff)
    set -g _dap_c_lav     (set_color -o eecbff)
    set -g _dap_c_white   (set_color ffffff)
    set -g _dap_c_gray    (set_color 999999)
    set -g _dap_c_rst     (set_color normal)

    # Preserved from Gold Master
    set -g _dap_sym_pac   "ᗧ"

    function _dap_cleanup
        set -e _dap_c_pink _dap_c_peach _dap_c_yellow _dap_c_mint _dap_c_blue _dap_c_lav _dap_c_white _dap_c_gray _dap_c_rst _dap_sym_pac
        functions -e __pkg_center __pkg_draw_header _dap_cleanup __pkg_startup_anim
    end

    function __pkg_center
        set -l str "$argv"
        set -l plain_str (string replace -ra '\x1b\[[0-9;]*m' '' "$str")
        set -l str_len (string length "$plain_str")
        set -l term_width $COLUMNS
        test -z "$term_width"; and set term_width 80
        set -l padding (math -s0 "($term_width - $str_len) / 2")
        if test $padding -gt 0; printf "%*s%s\n" $padding "" "$str"
        else; echo "$str"; end
    end

    # Preserved Startup Animation
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
            set -l plain_line (string replace -ra '\x1b\[[0-9;]*m' '' "$line")
            set -l str_len (string length "$plain_line")
            set -l term_width $COLUMNS
            if test -z "$term_width"
                set term_width 80
            end
            set -l padding (math -s0 "($term_width - $str_len) / 2")
            printf "\r%*s%s" $padding "" "$line"
            sleep 0.08
        end
        echo -e "\n"
        tput cnorm
    end

    function __pkg_draw_header
        clear
        set -l pkg_count (pacman -Qq | count)
        set -l cpu_temp "N/A"
        type -q sensors; and set cpu_temp (sensors 2>/dev/null | grep "Package id 0" | awk '{print $4}' | string replace '+' '')
        set -l ram_use (free -h | grep "Mem:" | awk '{print $3 "/" $2}')
        set -l load (uptime | awk -F'load average:' '{ print $2 }' | cut -d, -f1 | xargs)

        echo -e "$_dap_c_blue"
        __pkg_center "  ▄██████▄   ▄██████▄     ▄███████▄ ▄██████▄  ▄██████▄  ▄██████▄   ▄██████▄   ▄██████▄ "
        __pkg_center " ▀█▀    ▀█  ▀█▀    ▀█     ▀█▀     ▀█ ▀█▀    ▀█ ▀█▀    ▀█ ▀█▀    ▀█  ▀█▀    ▀█  ▀█▀    ▀█ "
        __pkg_center "  █      █   █      █      █       ▄▀  █      █  █      █  █      █   █      █   █      █ "
        __pkg_center "  █      █   █      █      █▄▄▄▄▄▀     █▄▄▄▄▄▄█  █      █  █▄▄▄▄▄▄█   █▄▄▄▄▄▄█   █▄▄▄▄▄▄▀ "
        __pkg_center "  █      █   █      █      █▀▀▀▀▀      █▀▀▀▀▀▀█  █      █  █▀▀▀▀▀▀█   █▀▀▀▀▀▀█   █▀▀▀▀▀   "
        __pkg_center "  █      █   █      █      █           █      █  █      █  █      █   █      █   █        "
        __pkg_center " ▄█▄    ▄█  ▄█▄    ▄█     ▄█▄         ▄█▄    ▄█ ▄█▄    ▄█ ▄█▄    ▄█  ▄█▄    ▄█  ▄█▄       "
        __pkg_center "  ▀██████▀   ▀██████▀      ▀           ▀      ▀  ▀██████▀  ▀      ▀   ▀      ▀   ▀        "
        echo -e "$_dap_c_rst"

        __pkg_center "$_dap_c_blue┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
        __pkg_center "$_dap_c_pink  DA-PACAGER $_dap_c_gray| $_dap_c_mint EliteDesk 800 G1 $_dap_c_gray| $_dap_c_lav CachyOS $_dap_c_rst"
        __pkg_center "$_dap_c_gray LOAD: $_dap_c_pink$load $_dap_c_gray TEMP: $_dap_c_pink$cpu_temp $_dap_c_gray RAM: $_dap_c_mint$ram_use $_dap_c_gray PKGS: $_dap_c_white$pkg_count$_dap_c_rst"
        __pkg_center "$_dap_c_yellow ⚠ POWER: 65W/135W BRICK - LIMIT CONCURRENCY IF VOLTAGE DROPS <18V $_dap_c_rst"
        __pkg_center "$_dap_c_blue┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"
    end

    # Run Startup Animation
    __pkg_startup_anim

    while true
        __pkg_draw_header
        echo ""
        __pkg_center "$_dap_c_lav╭── INQUIRY & DISCOVERY ─────╮  ╭── MODIFY & MAINTAIN ──────╮"
        __pkg_center "│  $_dap_c_mint [1] $_dap_c_white Search & Install    $_dap_c_lav │  │  $_dap_c_mint [7] $_dap_c_white Update (Repo Only)    $_dap_c_lav │"
        __pkg_center "│  $_dap_c_peach [2] $_dap_c_white Package Info (Qi/Si)$_dap_c_lav │  │  $_dap_c_peach [8] $_dap_c_white Update (Full/AUR)    $_dap_c_lav │"
        __pkg_center "│  $_dap_c_blue [3] $_dap_c_white Dependency Tree      $_dap_c_lav │  │  $_dap_c_blue [9] $_dap_c_white Update (Voltage Safe) $_dap_c_lav │"
        __pkg_center "│  $_dap_c_mint [4] $_dap_c_white File Finder (Owner)  $_dap_c_lav │  │  $_dap_c_mint [10] $_dap_c_white Remove & Clean       $_dap_c_lav │"
        __pkg_center "│  $_dap_c_peach [5] $_dap_c_white Arch News Feed       $_dap_c_lav │  │  $_dap_c_peach [11] $_dap_c_white Clear Caches          $_dap_c_lav │"
        __pkg_center "│  $_dap_c_blue [6] $_dap_c_white Cheat Sheet Search   $_dap_c_lav │  │  $_dap_c_blue [12] $_dap_c_white Senior Dev Utils     $_dap_c_lav │"
        __pkg_center "╰─────────────────────────────╯  ╰─────────────────────────────╯"
        __pkg_center "$_dap_c_pink [q] Terminate Session $_dap_c_rst"
        echo ""

        read -P " Action Request :: " choice

        switch $choice
            case 1
                yay -Slq | fzf --multi --header="Install (Tab to multi-select)" --preview "yay -Si {1}" | xargs -ro yay -S
            case 2
                read -P "Package Name: " pkg; and yay -Si $pkg; or yay -Qi $pkg
            case 3
                yay -Qq | fzf --header="Select for Tree" | xargs -r pactree | less
            case 4
                read -P "File Path (e.g. /usr/bin/ls): " fpath; and yay -Qo $fpath
            case 5
                curl -s https://archlinux.org/feeds/news/ | grep -E '<title>|<pubDate>' | sed 's/<[^>]*>//g' | head -n 10
            case 6
                read -P "Query: " query; and curl -s "cht.sh/$query" | less -R
            case 7
                sudo pacman -Syu
            case 8
                yay -Syu
            case 9
                # Safety for Haswell i7-4790S TDP 65W.
                # Prevents OCP trips on underpowered OEM bricks.
                env MAKEFLAGS="-j2" yay -Syu
            case 10
                echo "[1] Remove Package [2] Clean Orphans"
                read -P "> " rem_opt
                if test "$rem_opt" = "1"
                    yay -Qq | fzf --multi --header="Select to Remove" --preview "yay -Qi {1}" | xargs -ro yay -Rns
                else
                    set -l orphans (pacman -Qtdq); and sudo pacman -Rns $orphans; or echo "No orphans."
                end
            case 11
                echo "[1] Pacman Cache [2] Yay Cache"
                read -P "> " cache_opt
                test "$cache_opt" = "1"; and sudo pacman -Sc; or yay -Sc
            case 12
                echo "[1] Edit Fish [2] Backup Config [3] Refresh Mirrors [4] Service Manager [5] AVX2 Check [6] Unlock Database [7] List Installed"
                read -P "> " dev_opt
                switch $dev_opt
                    case 1; $EDITOR ~/.config/fish/config.fish
                    case 2; cp -r ~/.config ~/.config.bak; echo "Backup created."
                    case 3; sudo reflector --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist; and echo "Mirrors optimized."
                    case 4; systemctl list-unit-files --type=service | fzf --header="Manage Services" | awk '{print $1}' | xargs -r systemctl status
                    case 5; grep -q avx2 /proc/cpuinfo; and echo "AVX2 Support Verified for Haswell."; or echo "AVX2 Missing or Throttled."
                    case 6; sudo rm /var/lib/pacman/db.lck; and echo "Database unlocked."
                    case 7; pacman -Q | less
                end
            case q Q
                _dap_cleanup; clear; return 0
        end
        read -P "Return to Menu..." dummy
    end
end
echo -e "\033[0m"
