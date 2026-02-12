function gacp --description "Git add, commit, push"
    # 1. Check for commit message
    if test (count $argv) -eq 0
        echo (set_color red)"❌ Error: Missing commit message."(set_color normal)
        echo "Usage: gacp \"Commit message\""
        return 1
    end

    # 2. Show status and visual feedback
    echo (set_color blue)"📦 Staging all changes..."(set_color normal)
    git add .
    if test $status -ne 0
        echo (set_color red)"❌ Failed to stage changes."(set_color normal)
        return 1
    end

    # 3. Commit
    echo (set_color yellow)"📝 Committing: $argv"(set_color normal)
    git commit -m "$argv"
    if test $status -ne 0
        echo (set_color red)"❌ Commit failed."(set_color normal)
        return 1
    end

    # 4. Push
    echo (set_color magenta)"🚀 Pushing to remote..."(set_color normal)
    git push
    if test $status -ne 0
        echo (set_color red)"❌ Push failed."(set_color normal)
        return 1
    end

    echo (set_color green)"✅ Done!"(set_color normal)
end
