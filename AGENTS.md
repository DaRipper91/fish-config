# AGENTS.md — fish-config

## Project Overview
`fish-config` is DaRipper91's core production Fish shell environment. It contains shell configuration scripts, completion definitions, prompt utilities, environment exports, system telemetry functions (`da-stats`), and automated test harnesses.

- **Primary Shell:** Fish Shell 4.x / 3.x
- **Configuration Root:** `config.fish`, `conf.d/`
- **Functions Directory:** `functions/`
- **Completions Directory:** `completions/`
- **Test Harness:** `test/` (executed via `./run_tests.sh`)

---

## Technical Stack & Invariants
- **Compatibility:** Fish Shell 4.0+ (Rust rewrite) and Fish 3.x.
- **Floating-Point Comparison Rule:**
  Fish 4.0 removed boolean comparison operators (`>`, `<`) from `math`. Always scale floating point metrics to integer thresholds (e.g. `set -l scaled (math -s0 "$val * 100")` followed by `test $scaled -gt 400`) to guarantee cross-version reliability.
- **String Matching Flag Guard:**
  In `string match` invocations against multi-line or dynamic output that may contain leading dashes, always pass `--` before the pattern:
  ```fish
  string match -q -- "*pattern*" $output
  ```
- **Zero Secrets Invariant:**
  Never commit credentials, API keys, or live tokens. Secret variables belong in `secrets.fish` which is strictly ignored by `.gitignore`.
- **Single Source of Truth:**
  `AGENTS.md` in the repository root is canonical. `CLAUDE.md`, `GEMINI.md`, and `.cursorrules` are symlinks pointing directly to this file.

---

## Verification Runbooks
```bash
# Navigate to repository root
cd /home/daripper/Projects/fish-config

# Run all test suites
./run_tests.sh

# Run python logic checks
python3 test/verify_da_stats_logic.py
python3 test/verify_net_route_logic.py
```
