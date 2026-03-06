function gswitch
    set config ~/.gemini/settings.json
    # Extract current model name with fallback
    set current (jq -r '.model.name // .model // "gemini-2.0-flash"' $config)

    # Multi-model cycle logic
    switch "$current"
        case "gemini-2.0-flash"
            set new_model "gemini-2.0-flash-thinking-exp-01-21"
            set color blue
            set mode_name "🤔 GEMINI 2.0 THINKING (Deep Logic)"
        case "gemini-2.0-flash-thinking-exp-01-21"
            set new_model "gemini-2.0-pro-exp-02-05"
            set color green
            set mode_name "🧠 GEMINI 2.0 PRO (Maximum Intelligence)"
        case "gemini-2.0-pro-exp-02-05"
            set new_model "gemini-1.5-pro"
            set color magenta
            set mode_name "📚 GEMINI 1.5 PRO (Large Context)"
        case "gemini-1.5-pro"
            set new_model "gemini-3-flash-preview" # Assuming this is available/desired
            set color cyan
            set mode_name "⚡ GEMINI 3 FLASH (Speed & Logic)"
        case "*"
            set new_model "gemini-2.0-flash"
            set color yellow
            set mode_name "🚀 GEMINI 2.0 FLASH (Balanced)"
    end

    # Safe JSON update - ensuring we write to .model.name as per original desktop config
    jq --arg nm "$new_model" '.model = { "name": $nm }' $config > $config.tmp && mv $config.tmp $config
    
    set_color $color
    echo -e "Gemini CLI switched to: $mode_name"
    set_color normal
end
