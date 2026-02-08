function plan
    set -l prompt $argv
    if test -z "$prompt"
        read -P "plan >> " prompt
    end
    if test -z "$prompt"
        return 1
    end
    gemini "activate_skill implementation-planner; $prompt"
end
