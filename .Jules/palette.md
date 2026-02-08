## 2025-05-15 - CLI Dependency Checks
**Learning:** Shell scripts often fail silently or with confusing errors when external dependencies are missing.
**Action:** Always wrap external commands (like `jq`, `rclone`) with `type -q` checks to provide clear, actionable error messages to the user.
