## 2024-05-22 - Heavy External Forks in Prompt
**Learning:** The `fish_prompt` function relied heavily on external tools (`grep`, `awk`, `cut`, `ip`) which caused significant latency on every prompt render. Fish's built-in `read` and `string` manipulation are powerful enough to replace these.
**Action:** Always prefer Fish built-ins (`string match`, `string split`, `read`) over forking external processes in frequently executed functions.

## 2024-05-23 - Network Check Optimization
**Learning:** `ip route get` is a heavy operation for a prompt. Reading `/proc/net/route` directly and parsing with regex `\n(\S+)\s+00000000` is significantly faster. However, care must be taken with regex anchors (`\n` or `^`) to ensure the correct column is matched in tab-delimited files.
**Action:** Replace `ip` commands with `/proc` reads where possible, but verify column alignment with robust regex.
