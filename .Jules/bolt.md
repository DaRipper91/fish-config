## 2024-05-22 - [Fish Startup Performance]
**Learning:** Tools in `conf.d/` run on *every* shell startup (interactive & non-interactive). Unguarded process spawns (like `zoxide init`) here add significant latency to scripts, `scp`, and git hooks.
**Action:** Always guard interactive tools in `conf.d/` with `status is-interactive`.
