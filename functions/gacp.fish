function gacp --description "Git add, commit, push with style"
    # Check for commit message
    if test (count $argv) -eq 0
        echo (set_color red)"❌ Error: Commit message required."(set_color normal)
        echo "Usage: gacp \"Your commit message\""
        return 1
    end

    # Stage changes
    echo (set_color yellow)"📦 Staging all changes..."(set_color normal)
    git add .

    # Check if there are changes to commit
    # git diff --cached --quiet returns 0 if no changes, 1 if changes
    if git diff --cached --quiet
        echo (set_color yellow)"⚠️  Nothing to commit."(set_color normal)
        return 0
    end

    # Commit
    echo (set_color blue)"💾 Committing: \"$argv\"..."(set_color normal)
    if git commit -m "$argv"
        # Push
        echo (set_color magenta)"🚀 Pushing to remote..."(set_color normal)
        if git push
            echo (set_color green)"✨ Done!"(set_color normal)
        else
            echo (set_color red)"❌ Push failed."(set_color normal)
            return 1
        end
    else
        echo (set_color red)"❌ Commit failed."(set_color normal)
        return 1
    end
end
