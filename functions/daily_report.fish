function daily_report
    set bat_level (acpi -b | grep -P -o '[0-9]+(?=%)')
    set clip_content (xclip -o)

    echo "Analysis Start..."
    g "My battery is at $bat_level%. My clipboard contains: '$clip_content'. Give me a ruthless critique of my clipboard content and suggest one task based on my battery level."
end
