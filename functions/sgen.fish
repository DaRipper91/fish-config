function sgen
    set -l prompt $argv
    if test -z "$prompt"
        read -P "sgen >> " prompt
    end
    if test -z "$prompt"
        return 1
    end
    gemini "activate_skill skill-creator; $prompt"
end
