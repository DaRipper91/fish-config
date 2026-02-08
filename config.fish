# File Colors
set -gx LS_COLORS "di=01;38;2;255;0;102:ln=01;38;2;0;255;204:ex=01;38;2;57;255;0:*.zip=01;38;2;255;153;0:*.jpg=01;38;2;135;206;235:*.png=01;38;2;135;206;235"

# Google_API
# WARNING: Rotate this key immediately (see below)
set -gx GOOGLE_API_KEY "AIzaSyBT40zUR-cBMLDCCdcifXzIsdZ6wij3S0g"

# Starship Prompt
if status is-interactive
    starship init fish | source
end

# Gemini Model Switcher
# gswitch is autoloaded

# Google Drive Sync
# gpull is autoloaded

if status is-interactive
    fastfetch
end
alias sweep="python3 ~/ops/librarian.py"

# pnpm
set -gx PNPM_HOME "/home/daripper/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# Cargo
set -gx CARGO_HOME "$HOME/.cargo"
if not string match -q -- "$CARGO_HOME/bin" $PATH
  set -gx PATH "$CARGO_HOME/bin" $PATH
end
alias jarvis="terminal-jarvis"
fnm env --use-on-cd | source
