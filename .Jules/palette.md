## 2025-05-15 - CLI Dependency Checks
**Learning:** Shell scripts often fail silently or with confusing errors when external dependencies are missing.
**Action:** Always wrap external commands (like `jq`, `rclone`) with `type -q` checks to provide clear, actionable error messages to the user.

## 2025-05-16 - Fish Floating Point Logic
**Learning:** The `math` builtin in Fish (v3.7.0) supports arithmetic but logical operators like `>` for floats may require workarounds or fail.
**Action:** Use `awk 'BEGIN {exit !($val > threshold)}'` for reliable floating-point comparisons in scripts.

## 2025-05-17 - CLI Confirmation Patterns
**Learning:** CLI tools that perform bulk actions (like `git add .`) can be dangerous. Users appreciate a moment to pause and verify the scope of the action.
**Action:** Add an interactive confirmation step for bulk operations when running in interactive mode (no arguments).
