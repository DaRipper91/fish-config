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
        return 1
    end
end
