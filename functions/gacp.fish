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
        return 1
    end
end
