# File Colors
set -gx LS_COLORS "di=01;38;2;255;0;102:ln=01;38;2;0;255;204:ex=01;38;2;57;255;0:*.zip=01;38;2;255;153;0:*.jpg=01;38;2;135;206;235:*.png=01;38;2;135;206;235"

# Google_API
# Note: Key moved to secrets.fish (ignored by git) for security.
set -l secrets_file (dirname (status filename))/secrets.fish
if test -f $secrets_file
    source $secrets_file
else if not set -q GOOGLE_API_KEY
    echo "⚠️  GOOGLE_API_KEY not set. Please see secrets.fish.example"
end

# Starship Prompt
if status is-interactive
    starship init fish | source
end

# Gemini Model Switcher
function gswitch
    # Dependency check: jq
    if not type -q jq
        echo "❌ Error: 'jq' is not installed. Please install it to use this function."
        return 1
    end

    set config ~/.gemini/settings.json

    # Config file check
    if not test -f $config
        echo "❌ Error: Config file '$config' not found."
        return 1
    end

    set current (jq -r '.model.name // .model' $config)

    if string match -q "gemini-3-flash-preview" $current
        set new_model "gemini-3-pro-preview"
        set mode_name "🧠 GEMINI 3 PRO (Maximum Intelligence)"
    else
        set new_model "gemini-3-flash-preview"
        set mode_name "⚡ GEMINI 3 FLASH (Speed & Logic)"
    end

    # Safe JSON update
    jq --arg nm "$new_model" '.model = { "name": $nm }' $config > $config.tmp && mv $config.tmp $config
    echo -e "Gemini CLI switched to: $mode_name"
end

# Google Drive Sync
# gpull is autoloaded

if status is-interactive
    fastfetch
end
alias sweep="python3 ~/ops/librarian.py"

# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
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
