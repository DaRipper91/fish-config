## 2025-05-15 - CLI Dependency Checks
**Learning:** Shell scripts often fail silently or with confusing errors when external dependencies are missing.
**Action:** Always wrap external commands (like `jq`, `rclone`) with `type -q` checks to provide clear, actionable error messages to the user.

## 2025-05-16 - Fish Floating Point Logic
**Learning:** The `math` builtin in Fish (v3.7.0) supports arithmetic but logical operators like `>` for floats may require workarounds or fail.
**Action:** Use `awk 'BEGIN {exit !($val > threshold)}'` for reliable floating-point comparisons in scripts.

## 2026-02-14 - Visual Feedback in Destructive Commands
**Learning:** Destructive CLI commands (like `git push`) that run silently or with raw output can cause user anxiety and obscure errors.
**Action:** Use `set_color` and emojis to provide clear, step-by-step visual feedback (Staging -> Committing -> Pushing) and distinct success/error states.
