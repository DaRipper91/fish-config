## Source from conf.d before our fish config
source /usr/share/cachyos-fish-config/conf.d/done.fish


## Set values
## Run fastfetch as welcome message
function fish_greeting
    fastfetch
end

# Format man pages
set -x MANROFFOPT "-c"
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

## Environment setup
# Apply .profile: use this to put fish compatible .profile stuff in
if test -f ~/.fish_profile
  source ~/.fish_profile
end

# Add ~/.local/bin to PATH
if test -d ~/.local/bin
    if not contains -- ~/.local/bin $PATH
        set -p PATH ~/.local/bin
    end
end

# Add depot_tools to PATH
if test -d ~/Applications/depot_tools
    if not contains -- ~/Applications/depot_tools $PATH
        set -p PATH ~/Applications/depot_tools
    end
end


## Functions
# Functions needed for !! and !$ https://github.com/oh-my-fish/plugin-bang-bang
function __history_previous_command
  switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end

function __history_previous_command_arguments
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end

if [ "$fish_key_bindings" = fish_vi_key_bindings ];
  bind -Minsert ! __history_previous_command
  bind -Minsert '$' __history_previous_command_arguments
else
  bind ! __history_previous_command
  bind '$' __history_previous_command_arguments
end

# Fish command history
function history
    builtin history --show-time='%F %T '
end

function backup --argument filename
    cp $filename $filename.bak
end

# Copy DIR1 DIR2
function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
        set from (echo $argv[1] | trim-right /)
        set to (echo $argv[2])
        command cp -r $from $to
    else
        command cp $argv
    end
end

## Useful aliases
# Replace ls with eza
alias ls='eza -al --color=always --group-directories-first --icons' # preferred listing
alias la='eza -a --color=always --group-directories-first --icons'  # all files and dirs
alias ll='eza -l --color=always --group-directories-first --icons'  # long format
alias lt='eza -aT --color=always --group-directories-first --icons' # tree listing
alias l.="eza -a | grep -e '^\.'"                                     # show only dotfiles

# Common use
alias grubup="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias hw='hwinfo --short'                                   # Hardware Info
alias big="expac -H M '%m\t%n' | sort -h | nl"              # Sort installed packages according to size in MB
alias gitpkg='pacman -Q | grep -i "\-git" | wc -l'          # List amount of -git packages
alias update='sudo pacman -Syu'

# Get fastest mirrors
alias mirror="sudo cachyos-rate-mirrors"

# Help people new to Arch
alias apt='man pacman'
alias apt-get='man pacman'
alias please='sudo'
alias tb='nc termbin.com 9999'

# Cleanup orphaned packages
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

# 2. Kill the "Friendly" Greeting (Silent or Aggressive)
function fish_greeting
     echo -e "\e[1;31m⚠ YE BE ROOT MY DUUUUDE ⚠\e[0m"
end

# 4. Custom "Root Access" Aliases (Add only what CachyOS doesn't have)
# CachyOS already has 'update', 'll', 'ls', etc.
alias rm="rm -I"
alias cp="cp -i"
alias mv="mv -i"
alias unlock="sudo rm /var/lib/pacman/db.lck"

# 5. Fix for Tiling Managers (Optional)
# If your Java apps (like Minecraft or Ghidra) are blank in tiling window managers:
set -x _JAVA_AWT_WM_NONREPARENTING 1

# 3. Force Starship (Overrides CachyOS prompt)
# Note: Ensure you installed starship: sudo pacman -S starship
  starship init fish | source

function gchat --description "Interactive Gemini session with auto-buffering"
    # -q: Quiet mode (suppresses "Script started..." messages)
     -c: Command to execute
     Captures full session to /tmp/gemini_buffer.raw
    script -q /tmp/gemini_buffer.raw -c "gemini chat"
end

function keep --description "Persist the last buffered Gemini session"
    set -l log_dir "$HOME/gemini_logs"
    
    if test -f /tmp/gemini_buffer.raw

        # Create dir if missing
        mkdir -p $log_dir
        
        set -l timestamp (date +%Y%m%d_%H%M%S)
        set -l filename "$log_dir/session_$timestamp.txt"
        
        # 'col -b' is critical: It strips ANSI colors and 
        # backspace characters so the file is readable text.
        col -b < /tmp/gemini_buffer.raw > $filename
        
        echo ":: 💾 Session saved to: $filename"
    else
        echo ":: ⚠️  No buffer found. Did you run 'gchat'?"
    end
end

function gmi --description 'Run gemini-cli with auto-yes'
    yes | gemini-cli $argv
end


starship init fish | source
