function starship-command --description "Launch the Starship-Command visual prompt IDE"
    set -l app_bin "$HOME/Projects/Starship-Command/starship-command-python.sh"
    if test -x "$app_bin"
        eval "$app_bin" $argv
    else
        echo "Starship-Command not found at $app_bin"
        return 1
    end
end
