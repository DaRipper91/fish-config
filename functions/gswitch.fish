function gswitch
    set config ~/.gemini/settings.json
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
