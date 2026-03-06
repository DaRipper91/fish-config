function dainit --description 'Bootstrap AI agent instruction files into a project directory'
    set -l MASTER "$HOME/Projects/AGENTS.md"

    if not test -f "$MASTER"
        echo "ERROR: Master ruleset not found at $MASTER"
        return 1
    end

    # Arguments
    set -l TARGET_DIR "."
    if test (count $argv) -ge 1
        set TARGET_DIR $argv[1]
    end

    set TARGET_DIR (realpath "$TARGET_DIR")

    if not test -d "$TARGET_DIR"
        echo "ERROR: Target directory does not exist: $TARGET_DIR"
        return 1
    end

    set -l PROJECT_NAME (basename "$TARGET_DIR")
    if test (count $argv) -ge 2
        set PROJECT_NAME $argv[2]
    end

    set -l PROJECT_DESC "Add a short description of this project here."
    if test (count $argv) -ge 3
        set PROJECT_DESC $argv[3]
    end

    echo "→ Bootstrapping agent rules into: $TARGET_DIR"
    echo "  Project name : $PROJECT_NAME"
    echo "  Description  : $PROJECT_DESC"
    echo ""

    # Read master ruleset and strip existing project-specific sections
    # sed '/## Project:/Q' prints until the line before the first "## Project:"
    set -l UNIVERSAL (sed '/## Project:/Q' "$MASTER")

    # Project-specific section template
    set -l PROJECT_SECTION "## Project: $PROJECT_NAME

$PROJECT_DESC

### Commands

```sh
# TODO: fill in build / run / test / lint commands for this project
# Example:
# npm run dev        # start dev server
# npm run build      # production build
# npm run lint       # lint
# npm test           # run tests
```

### Architecture

TODO: describe the high-level architecture, key directories, and data flow.

### Key Conventions

TODO: list any project-specific conventions agents must follow (naming patterns,
state management rules, restricted APIs, etc.)."

    # Files to create
    set -l FILES "AGENTS.md" "CLAUDE.md" ".github/copilot-instructions.md" ".cursorrules" ".windsurfrules"

    for file in $FILES
        set -l path "$TARGET_DIR/$file"
        set -l dir (dirname "$path")

        mkdir -p "$dir"

        if test -f "$path"
            echo "  ⚠  EXISTS (overwriting): $path"
        else
            echo "  ✓  Created: $path"
        end

        # Write the universal rules
        printf "%s\n" $UNIVERSAL > "$path"
        # Append the project-specific section
        printf "\n%s\n" "$PROJECT_SECTION" >> "$path"
    end

    echo ""
    echo "Done. Files created in: $TARGET_DIR"
    echo ""
    echo "Next steps:"
    echo "  1. Open each generated file and fill in the TODO sections."
    echo "  2. Commit all five files."
    echo "  3. When you update ~/Projects/AGENTS.md, re-run 'dainit' to propagate changes."
end
