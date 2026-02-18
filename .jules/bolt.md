## 2024-05-22 - Heavy External Forks in Prompt
**Learning:** The `fish_prompt` function relied heavily on external tools (`grep`, `awk`, `cut`, `ip`) which caused significant latency on every prompt render. Fish's built-in `read` and `string` manipulation are powerful enough to replace these.
**Action:** Always prefer Fish built-ins (`string match`, `string split`, `read`) over forking external processes in frequently executed functions.
