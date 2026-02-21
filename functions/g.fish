function g --wraps gemini
    # Check for gemini command
    if not type -q gemini
        echo (set_color red)"Error: 'gemini' command not found."(set_color normal) >&2
        return 1
    end

    # Check if a prompt was provided via arguments
    if count $argv > /dev/null
        # Create a temporary file for the output
        set -l temp_out (mktemp)

        # Trap SIGINT to clean up and restore cursor if interrupted
        # Note: $temp_out is expanded when the trap is defined
        trap "rm -f $temp_out; if type -q tput; tput cnorm >&2; end; exit 1" SIGINT

        # Run gemini in the background, redirecting stdout to the temp file
        # We let stderr go to the terminal (e.g. for errors)
        command gemini prompt $argv > $temp_out &
        set -l pid $last_pid

        # Update trap to include killing the background process
        trap "rm -f $temp_out; kill $pid 2>/dev/null; if type -q tput; tput cnorm >&2; end; exit 1" SIGINT

        # Spinner visual (only if stderr is a TTY)
        if test -t 2
            set -l spin_chars "⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏"
            set -l i 1

            # Hide cursor
            if type -q tput
                tput civis >&2
            end

            # Loop while the process is running
            while kill -0 $pid 2>/dev/null
                printf "\r%s Thinking..." $spin_chars[$i] >&2
                set i (math "$i % 10 + 1")
                sleep 0.1
            end

            # Restore cursor and clear line
            printf "\r\033[K" >&2
            if type -q tput
                tput cnorm >&2
            end
        end

        # Wait for the process to finish and capture its exit status
        # Even if the loop finished, wait ensures we get the exit code
        wait $pid
        set -l exit_status $status

        # Clear trap to return to default behavior
        trap - SIGINT

        # Output the result
        cat $temp_out
        rm -f $temp_out

        return $exit_status
    else
        # No args? Enter interactive chat mode
        command gemini chat
    end
end
