function gacp --description "Git add, commit, push with style"
    # Check if inside a git repository
    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo (set_color red)"❌ Not a git repository"(set_color normal)
        return 1
    end

    # Check for changes
    if test -z (git status --porcelain)
        echo (set_color yellow)"🧹 Clean working directory. Nothing to commit."(set_color normal)
        return 0
    end

    # Show status
    echo (set_color blue)"📝 Changes detected:"(set_color normal)
    git status --short

    # Get commit message
    set -l msg "$argv"

    # If no message provided, ask for it
    if test -z "$msg"
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
