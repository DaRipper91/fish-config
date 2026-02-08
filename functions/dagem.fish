function dagem
    set gem_name $argv[1]; set user_prompt $argv[2..-1] 
    set gem_path "$HOME/ops/gems/$gem_name.md"; set log_file "$HOME/ops/archive/raw/chat_history.jsonl"
    if not test -f "$gem_path"; echo "💀 Gem '$gem_name' not found."; return 1; end
    set response (gemini chat --system "$(cat $gem_path)" -m "$user_prompt")
    echo $response
    set safe_prompt (echo $user_prompt | string replace -a '"' '\"'); set safe_response (echo $response | string replace -a '"' '\"')
    echo "{\"timestamp\": \"$(date '+%Y-%m-%d %H:%M:%S')\", \"gem\": \"$gem_name\", \"prompt\": \"$safe_prompt\", \"response\": \"$safe_response\"}" >> $log_file
end