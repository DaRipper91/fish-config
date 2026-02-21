## 2025-05-15 - CLI Dependency Checks
**Learning:** Shell scripts often fail silently or with confusing errors when external dependencies are missing.
**Action:** Always wrap external commands (like `jq`, `rclone`) with `type -q` checks to provide clear, actionable error messages to the user.

## 2025-05-16 - Fish Floating Point Logic
**Learning:** The `math` builtin in Fish (v3.7.0) supports arithmetic but logical operators like `>` for floats may require workarounds or fail.
**Action:** Use `awk 'BEGIN {exit !($val > threshold)}'` for reliable floating-point comparisons in scripts.

## 2026-02-14 - Visual Feedback in Destructive Commands
**Learning:** Destructive CLI commands (like `git push`) that run silently or with raw output can cause user anxiety and obscure errors.
**Action:** Use `set_color` and emojis to provide clear, step-by-step visual feedback (Staging -> Committing -> Pushing) and distinct success/error states.
## 2025-05-18 - Destructive CLI Commands
**Learning:** Users often run destructive commands (like git push wrappers) without confirmation or checking the state, leading to errors or unintended actions.
**Action:** Transform silent, dangerous scripts into interactive tools that verify context (e.g., git repo, staged changes) and provide step-by-step visual feedback before executing.
## 2025-05-20 - Visualizing Resource Load
**Learning:** Raw "Load Average" numbers are confusing for most users. Showing load as a percentage of available cores (using `nproc`) provides immediate, actionable context.
**Action:** Always convert raw system metrics into relative percentages (clamped to 100% for display) to reduce cognitive load.
## 2025-05-17 - CLI Confirmation Patterns
**Learning:** CLI tools that perform bulk actions (like `git add .`) can be dangerous. Users appreciate a moment to pause and verify the scope of the action.
**Action:** Add an interactive confirmation step for bulk operations when running in interactive mode (no arguments).

## 2025-05-18 - Async CLI Feedback
**Learning:** Users often perceive CLI tools as "hung" when they perform background tasks like API calls without visual feedback.
**Action:** Always provide a visual indicator (like a spinner) for long-running operations (>1s), while ensuring output is redirected properly (stderr vs stdout) to support piping.
