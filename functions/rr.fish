function rr
    set -l prompt $argv
    if test -z "$prompt"
        read -P "rr >> " prompt
    end
    if test -z "$prompt"
        return 1
    end
    gemini "activate_skill ruthless-refactorer; $prompt"
end
