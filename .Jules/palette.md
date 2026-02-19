## 2025-05-15 - CLI Dependency Checks
**Learning:** Shell scripts often fail silently or with confusing errors when external dependencies are missing.
**Action:** Always wrap external commands (like `jq`, `rclone`) with `type -q` checks to provide clear, actionable error messages to the user.

## 2025-05-16 - Fish Floating Point Logic
**Learning:** The `math` builtin in Fish (v3.7.0) supports arithmetic but logical operators like `>` for floats may require workarounds or fail.
**Action:** Use `awk 'BEGIN {exit !($val > threshold)}'` for reliable floating-point comparisons in scripts.

## 2025-05-20 - Visualizing Resource Load
**Learning:** Raw "Load Average" numbers are confusing for most users. Showing load as a percentage of available cores (using `nproc`) provides immediate, actionable context.
**Action:** Always convert raw system metrics into relative percentages (clamped to 100% for display) to reduce cognitive load.
