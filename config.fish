# File Colors
set -gx LS_COLORS "di=01;38;2;255;0;102:ln=01;38;2;0;255;204:ex=01;38;2;57;255;0:*.zip=01;38;2;255;153;0:*.jpg=01;38;2;135;206;235:*.png=01;38;2;135;206;235"

# --- Google API & Secrets Management ---
# Keys are moved to secrets.fish (ignored by git) for security.
set -l secrets_file (dirname (status filename))/secrets.fish
if test -f $secrets_file
    source $secrets_file
else
    if not set -q GOOGLE_API_KEY
        echo "⚠️  GOOGLE_API_KEY not set. Please see secrets.fish.example"
    end
end

# --- Path Management ---
# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end

# Cargo
set -gx CARGO_HOME "$HOME/.cargo"
if not string match -q -- "$CARGO_HOME/bin" $PATH
    set -gx PATH "$CARGO_HOME/bin" $PATH
end

# --- Interactive Session Setup ---
if status is-interactive
    # Prompt & Welcome
    starship init fish | source
    fastfetch

    # Tool Environments
    fnm env --use-on-cd | source

    # Aliases
    alias sweep="python3 ~/ops/librarian.py"
    alias jarvis="terminal-jarvis"
end
