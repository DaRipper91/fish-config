function fixthis --description 'Analyze the last failed command'
    set last_cmd $history[1]
    
    set_color yellow
    echo "⚠️  SAFETY CHECK: You are about to RE-RUN the following command to capture its error:"
    set_color -o red
    echo "   $last_cmd"
    set_color normal
    echo ""
    read -P "Do you want to proceed? [y/N] " confirm

    if string match -qi "y" $confirm
        echo '🚑 Executing and capturing output...'
        
        # Run command, capture stdout and stderr, and keep as single string
        set error_log (eval $last_cmd 2>&1 | string collect)
        
        echo "🧠 Consulting the Coder..."
        dagem coder "The command '$last_cmd' failed. 

        HERE IS THE OUTPUT/ERROR LOG:
        ```
        $error_log
        ```
        
        TASK:
        1. Explain why it failed.
        2. Provide the corrected command."
    else
        echo "🚫 Analysis aborted. Stay safe."
    end
end