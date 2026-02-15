## 2025-05-15 - CLI Dependency Checks
**Learning:** Shell scripts often fail silently or with confusing errors when external dependencies are missing.
**Action:** Always wrap external commands (like `jq`, `rclone`) with `type -q` checks to provide clear, actionable error messages to the user.

## 2025-05-16 - Fish Floating Point Logic
**Learning:** The `math` builtin in Fish (v3.7.0) supports arithmetic but logical operators like `>` for floats may require workarounds or fail.
**Action:** Use `awk 'BEGIN {exit !($val > threshold)}'` for reliable floating-point comparisons in scripts.

## 2025-05-18 - Destructive CLI Commands
**Learning:** Users often run destructive commands (like git push wrappers) without confirmation or checking the state, leading to errors or unintended actions.
**Action:** Transform silent, dangerous scripts into interactive tools that verify context (e.g., git repo, staged changes) and provide step-by-step visual feedback before executing.
