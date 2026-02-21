function dagem
    set -l gem_name $argv[1]
    set -l user_prompt $argv[2..-1]
    set -l gem_path "$HOME/ops/gems/$gem_name.md"
    set -l log_file "$HOME/ops/archive/raw/chat_history.jsonl"

    if not test -f "$gem_path"
        echo "💀 Gem '$gem_name' not found."
        return 1
    end

    # Create temporary file for output
    set -l temp_out (mktemp)

    # Start Gemini in background
    gemini chat --system "$(cat $gem_path)" -m "$user_prompt" > $temp_out &
    set -l pid $last_pid

    # Spinner animation
    set -l spin_chars "⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏"
    set -l i 1
    if type -q tput
        tput civis # Hide cursor
    end

    while kill -0 $pid 2>/dev/null
        printf "\r%s Thinking..." $spin_chars[$i]
        set i (math "$i % 10 + 1")
        sleep 0.1
    end

    if type -q tput
        tput cnorm # Show cursor
    end
    printf "\r\033[K" # Clear line

    # Read output (preserving newlines)
    # read -z reads until EOF
    read -z response < $temp_out
    rm -f $temp_out

    # Output response
    echo "$response"

    # Log to history safely
    set -l timestamp (date '+%Y-%m-%d %H:%M:%S')

    # Use jq for safe JSON creation if available, fallback to manual if not
    if type -q jq
        jq -n -c --arg t "$timestamp" --arg g "$gem_name" --arg p "$user_prompt" --arg r "$response" \
            '{timestamp: $t, gem: $g, prompt: $p, response: $r}' >> $log_file
    else
        # Fallback (less safe but keeps existing behavior)
        set -l safe_prompt (echo "$user_prompt" | string replace -a '"' '\"')
        set -l safe_response (echo "$response" | string replace -a '"' '\"')
        echo "{\"timestamp\": \"$timestamp\", \"gem\": \"$gem_name\", \"prompt\": \"$safe_prompt\", \"response\": \"$safe_response\"}" >> $log_file
    end
end
