function g --wraps gemini
    # Check if a prompt was provided via arguments
    if count $argv > /dev/null
        command gemini prompt $argv
    else
        # No args? Enter interactive chat mode
        command gemini chat
    end
end
