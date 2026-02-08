function cimp
    set -l prompt $argv
    if test -z "$prompt"
        read -P "cimp >> " prompt
    end
    if test -z "$prompt"
        return 1
    end
    gemini "activate_skill code-implementer; $prompt"
end
