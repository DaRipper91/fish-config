function pchk
    set -l prompt $argv
    if test -z "$prompt"
        read -P "pchk >> " prompt
    end
    if test -z "$prompt"
        return 1
    end
    gemini "activate_skill plan-reviewer; $prompt"
end
