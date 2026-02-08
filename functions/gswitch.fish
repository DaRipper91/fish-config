function gswitch --description "Toggle between Gemini Flash and Pro models"
    # Dependency check: jq
    if not type -q jq
        echo "❌ Error: 'jq' is not installed. Please install it to use this function."
        return 1
    end

    set config ~/.gemini/settings.json

    # Config file check
    if not test -f $config
        echo "❌ Error: Config file '$config' not found."
        return 1
    end

    set current (jq -r '.model.name // .model' $config)

    if string match -q "gemini-3-flash-preview" $current
        set new_model "gemini-3-pro-preview"
        set mode_name "🧠 GEMINI 3 PRO (Maximum Intelligence)"
    else
        set new_model "gemini-3-flash-preview"
        set mode_name "⚡ GEMINI 3 FLASH (Speed & Logic)"
    end

    # Safe JSON update
    jq --arg nm "$new_model" '.model = { "name": $nm }' $config > $config.tmp && mv $config.tmp $config
    echo -e "Gemini CLI switched to: $mode_name"
end
