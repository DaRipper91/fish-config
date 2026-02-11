function daily_report --description "Generate a system status report using Gemini"
    # Check for Gemini function
    if not functions -q g
        echo "❌ Error: The 'g' function (Gemini) is not available."
        return 1
    end

    # Check for ACPI (battery)
    if not type -q acpi
        echo "❌ Error: 'acpi' is not installed. Cannot retrieve battery status."
        return 1
    end

    # Check for clipboard utility
    set -l clip_cmd
    if type -q wl-paste
        set clip_cmd "wl-paste"
    else if type -q xclip
        set clip_cmd "xclip -o"
    else if type -q xsel
        set clip_cmd "xsel -o"
    else
        echo "❌ Error: No clipboard utility found (need wl-paste, xclip, or xsel)."
        return 1
    end

    echo "🔍 Analyzing system state..."

    # Get battery level safely
    set -l bat_level (acpi -b | grep -P -o '[0-9]+(?=%)')
    if test -z "$bat_level"
        set bat_level "unknown"
    end

    # Get clipboard content safely
    set -l clip_content (eval $clip_cmd 2>/dev/null)
    if test -z "$clip_content"
        echo "⚠️  Clipboard is empty or unreadable."
        set clip_content "[Empty Clipboard]"
    end

    echo "🤖 Asking Gemini for insights..."
    g "My battery is at $bat_level%. My clipboard contains: '$clip_content'. Give me a ruthless critique of my clipboard content and suggest one task based on my battery level."
end
