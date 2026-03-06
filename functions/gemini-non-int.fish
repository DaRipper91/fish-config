# Force gemini-cli to run without waiting for manual input
function gemini-non-int
    set -l prompt $argv
    echo "$prompt" | gemini-cli --quiet
end
