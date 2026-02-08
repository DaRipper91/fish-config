function prd
    set -l prompt $argv
    if test -z "$prompt"
        read -P "PRD >> " prompt
    end
    if test -z "$prompt"
        return 1
    end
    gemini "/pickle-prd $prompt"
end
