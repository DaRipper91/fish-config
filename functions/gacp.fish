function gacp --description "Git add, commit, push with style"
    # Check for empty commit message
    if test (count $argv) -eq 0
        echo (set_color red)"❌ Error: Commit message required."(set_color normal)
        echo "Usage: "(set_color yellow)"gacp \"Your commit message\""(set_color normal)
        return 1
    end

    # Staging
    echo (set_color cyan)"📦 Staging all changes..."(set_color normal)
    if not git add .
        echo (set_color red)"❌ Failed to stage changes."(set_color normal)
        return 1
    end

    # Committing
    echo (set_color blue)"💾 Committing: $argv"(set_color normal)
    if not git commit -m "$argv"
        echo (set_color red)"❌ Commit failed (maybe nothing to commit?)."(set_color normal)
        return 1
    end

    # Pushing
    echo (set_color magenta)"🚀 Pushing to remote..."(set_color normal)
    if git push
        echo (set_color green)"✅ Changes pushed successfully!"(set_color normal)
    else
        echo (set_color red)"❌ Push failed."(set_color normal)
function gacp --description "Git Add, Commit, Push with style"
    # Check if in a git repository
    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo (set_color red)"❌ Not a git repository!"(set_color normal)
        return 1
    end

    # Check for changes (staged or unstaged)
    if test -z (git status --porcelain)
        echo (set_color yellow)"✨ No changes to commit."(set_color normal)
        return 0
    end

    # Stage changes
    echo (set_color blue)"📦 Staging all changes..."(set_color normal)
    git add .

    # Show status summary
    git status --short

    # Get commit message if not provided
    set -l msg "$argv"
    if test -z "$msg"
        echo -n (set_color green)"📝 Enter commit message: "(set_color normal)
        read msg
    end

    # Validate message
    if test -z "$msg"
        echo (set_color red)"❌ Commit message required!"(set_color normal)
        return 1
    end

    # Commit
    echo (set_color blue)"💾 Committing..."(set_color normal)
    if git commit -m "$msg"
        # Push
        echo (set_color blue)"🚀 Pushing to remote..."(set_color normal)
        if git push
            echo (set_color green)"✅ Done!"(set_color normal)
        else
            echo (set_color red)"❌ Push failed!"(set_color normal)
            return 1
        end
    else
        echo (set_color red)"❌ Commit failed!"(set_color normal)
function gacp --description "Git add, commit, push with style"
    # Check if inside a git repository
    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo (set_color red)"❌ Not a git repository"(set_color normal)
        return 1
    end

    # Check for changes
    set -l changes (git status --porcelain)
    if test -z "$changes"
        echo (set_color yellow)"🧹 Clean working directory. Nothing to commit."(set_color normal)
        return 0
    end

    set -l changes_count (count $changes)

    # Show status
    echo (set_color blue)"📝 $changes_count changes detected:"(set_color normal)
    git status --short

    # Get commit message
    set -l msg "$argv"

    # If no message provided, ask for it (Interactive Mode)
    if test -z "$msg"
        echo
        # improved UX: Confirm action before proceeding
        read -p "set_color yellow; echo -n \"Stage and commit all $changes_count changes? [Y/n] \"; set_color normal" -l confirm
        if test "$confirm" = "n" -o "$confirm" = "N"
            echo (set_color red)"❌ Aborted."(set_color normal)
            return 1
        end

        # Use -p to execute a command for the prompt, ensuring colors work correctly
        read -p 'set_color green; echo -n "💬 Enter commit message: "; set_color normal' -l input_msg
        set msg "$input_msg"
    end

    if test -z "$msg"
        echo (set_color red)"❌ Commit message required"(set_color normal)
        return 1
    end

    # Execute commands
    echo (set_color cyan)"📦 Staging all changes..."(set_color normal)
    git add .

    echo (set_color cyan)"💾 Committing..."(set_color normal)
    if git commit -m "$msg"
        echo (set_color cyan)"🚀 Pushing to remote..."(set_color normal)
        if git push
            echo (set_color green)"✅ Done!"(set_color normal)
        else
            echo (set_color red)"❌ Push failed"(set_color normal)
            return 1
        end
    else
        echo (set_color red)"❌ Commit failed"(set_color normal)
        return 1
    end
end
