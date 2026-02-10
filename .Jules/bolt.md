## 2024-05-22 - [Fish Shell Optimization]
**Learning:** External commands like `dirname` in `config.fish` create measurable latency during shell startup because they fork a process. Replacing them with built-in string manipulation functions (like `string replace`) avoids this overhead, making startup faster.
**Action:** Always prefer shell built-ins over external commands in initialization scripts.
