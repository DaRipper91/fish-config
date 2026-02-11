## 2025-05-15 - CLI Dependency Checks
**Learning:** Shell scripts often fail silently or with confusing errors when external dependencies are missing.
**Action:** Always wrap external commands (like `jq`, `rclone`) with `type -q` checks to provide clear, actionable error messages to the user.

## 2025-05-16 - Fish Floating Point Logic
**Learning:** The `math` builtin in Fish (v3.7.0) supports arithmetic but logical operators like `>` for floats may require workarounds or fail.
**Action:** Use `awk 'BEGIN {exit !($val > threshold)}'` for reliable floating-point comparisons in scripts.

## 2025-05-17 - Feedback in Destructive Commands
**Learning:** Users often run "convenience" commands like `gacp` without thinking. Providing clear visual status (colors/emojis) and error handling prevents silent failures and builds trust.
**Action:** Enhance composite commands (like git shortcuts) with step-by-step status feedback and explicit error checks.
