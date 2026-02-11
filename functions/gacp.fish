function gacp --description "Git add, commit, push with feedback"
    if test (count $argv) -eq 0
        echo (set_color red)"❌ Error: Commit message required."(set_color normal)
        return 1
    end

    echo (set_color yellow)"📦 Staging all files..."(set_color normal)
    if not git add .
        echo (set_color red)"❌ 'git add' failed."(set_color normal)
        return 1
    end

    echo (set_color cyan)"📝 Committing..."(set_color normal)
    if not git commit -m "$argv"
        echo (set_color red)"❌ 'git commit' failed."(set_color normal)
        return 1
    end

    echo (set_color purple)"🚀 Pushing to remote..."(set_color normal)
    if not git push
        echo (set_color red)"❌ 'git push' failed."(set_color normal)
        return 1
    end

    echo (set_color green)"✨ Done!"(set_color normal)
end
