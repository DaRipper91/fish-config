## 2024-05-22 - [Fish Shell Optimization]
**Learning:** External commands like `dirname` in `config.fish` create measurable latency during shell startup because they fork a process. Replacing them with built-in string manipulation functions (like `string replace`) avoids this overhead, making startup faster.
**Action:** Always prefer shell built-ins over external commands in initialization scripts.

## 2024-10-24 - [Find Command Efficiency]
**Learning:** Using `grep` to filter `find` output is a performance trap for exclusions. `find` still traverses the excluded directories (like `node_modules`) before piping to `grep`. Using `-prune` prevents traversal entirely, resulting in massive speedups (5x+).
**Action:** Always use `-prune` in `find` commands to exclude directories, rather than post-processing filters.
