function rrev
    set -l prompt $argv
    if test -z "$prompt"
        read -P "rrev >> " prompt
    end
    if test -z "$prompt"
        return 1
    end
    gemini "activate_skill research-reviewer; $prompt"
end
