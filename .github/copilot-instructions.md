# Copilot Instructions

This is a personal Fish shell configuration repository with 60+ custom functions, plugins managed via Fisher, and an interactive installer for Termux and Arch Linux environments.

## Commands

```bash
# Run all tests
bash run_tests.sh

# Run a single test
fish test/<name>.test.fish

# Install config to system
bash install.sh
```

## Architecture

- **`config.fish`** — Entry point. Sources `secrets.fish` (not tracked), configures PATH (pnpm, cargo, fnm, `~/.local/bin`), initializes Starship and fastfetch.
- **`functions/`** — All custom functions, autoloaded by Fish. Covers Gemini AI wrappers (`g`, `dagem`, `gswitch`), Google Drive sync (`gpull`, `gpush`, `da-up`, `da-sync`), system monitoring (`da-stats`, `da-find`), and git helpers (`gacp`, `rr`).
- **`conf.d/`** — Auto-sourced on shell start. Gated with `status is-interactive` / `if not status is-interactive; exit; end` to avoid overhead in non-interactive contexts.
- **`test/`** — Fish test files. Run by `run_tests.sh` (matches `test/*.test.fish` and `test/test_*.fish`).
- **`fish_plugins`** — Source of truth for Fisher plugins: `jorgebucaran/fisher`, `jethrokuan/z`, `patrickf1/fzf.fish`, `jorgebucaran/autopair.fish`.

## Key Conventions

### Naming
- Public functions: `lowercase-with-hyphens` (e.g., `da-stats`, `gswitch`)
- Private/helper functions: `_underscore_prefixed` (e.g., `_da_print_bar`)
- Helper functions defined inside a command must be cleaned up with `functions -e _helper_name` at the end

### Dependency checks
Always guard external commands with `type -q` before use:
```fish
if not type -q jq
    echo (set_color red)"Error: 'jq' not found."(set_color normal) >&2
    return 1
end
```

### Background processes + spinner pattern
For long-running operations (e.g., API calls), use a temp file + background process + spinner. Write spinner output to stderr so stdout remains pipeable:
```fish
set -l temp_out (mktemp)
trap "rm -f $temp_out; kill $pid 2>/dev/null; tput cnorm >&2; exit 1" SIGINT
command foo $argv > $temp_out &
set -l pid $last_pid

if test -t 2
    tput civis >&2  # Hide cursor
    set -l spin_chars "⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏"
    set -l i 1
    while kill -0 $pid 2>/dev/null
        printf "\r%s Working..." $spin_chars[$i] >&2
        set i (math "$i % 10 + 1")
        sleep 0.1
    end
    printf "\r\033[K" >&2
    tput cnorm >&2  # Restore cursor
end

wait $pid; set -l exit_status $status
trap - SIGINT
cat $temp_out; rm -f $temp_out
return $exit_status
```

> **Note:** Fish shell does not support `trap` — this pattern is used in `g.fish` and `dagem.fish` but is a known limitation. For proper Fish signal handling, use `function --on-signal SIGINT` or `function --on-event fish_exit`.

### Visual feedback
Use `set_color` + emojis for step-by-step output. Consistent color semantics:
- `set_color green` + ✅ — success
- `set_color red` + ❌ — error
- `set_color yellow` + ⚠️ — warning/confirmation prompt
- `set_color blue`/`set_color cyan` + emoji (📦, 💾, 🚀) — progress steps

### Performance: prefer Fish built-ins over external forks
Especially critical in `fish_prompt` and `conf.d/` files that run on every prompt or shell start:
```fish
# ❌ Slow — forks external processes
df -hP / | grep / | awk '{print $5}' | cut -d'%' -f1

# ✅ Fast — Fish built-ins only
df -hP / | string match -v 'Filesystem*' | read -l -a disk_data
set disk_p (string replace '%' '' $disk_data[5])
```
Read `/proc/loadavg`, `/proc/net/route`, etc. directly instead of calling `uptime` or `ip`.

### Floating-point comparisons
Fish's `math` builtin doesn't support `>` for float conditions reliably. Use awk:
```fish
if awk "BEGIN {exit !($val > $threshold)}"
    # val exceeds threshold
end
```

### Test structure
Each test file: mocks external commands as Fish functions, sources the function under test, runs assertions with `string match -q`, sets a `$failed` flag or exits `1` on failure, prints `✅ PASS` / `❌ FAIL` messages.
```fish
function df
    echo "Filesystem  Size  Used  Avail  Use%  Mounted on"
    echo "/dev/root    50G   20G    27G   42%  /"
end

source functions/da-stats.fish

set output (da-stats)
if not string match -q "*Disk Usage:*42%*" $output
    echo "❌ disk usage wrong"; exit 1
end
echo "✅ passed"
```
