function tm
    set -l prompt $argv
    if test -z "$prompt"
        read -P "tm >> " prompt
    end
    if test -z "$prompt"
        return 1
    end
    gemini "activate_skill ticket-manager; $prompt"
end
