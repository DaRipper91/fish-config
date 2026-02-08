function loadgem --description "Summon a Gem context to the clipboard"
    set gem_name $argv[1]
    set gem_path "$HOME/ops/gems/$gem_name.md"

    if test -f "$gem_path"
        # Use wl-copy if on Wayland, or xclip/xsel if on X11. 
        # Since we are on CachyOS, likely Wayland or X11. Let's try standard cat first.
        
        # Check for clipboard tools
        if type -q wl-copy
            cat "$gem_path" | wl-copy
            echo "💎 Gem '$gem_name' loaded to clipboard. Just paste it."
        else if type -q xclip
            cat "$gem_path" | xclip -selection clipboard
            echo "💎 Gem '$gem_name' loaded to clipboard. Just paste it."
        else
            echo "❌ No clipboard tool found (install wl-clipboard or xclip)."
            echo "Here is the raw output:"
            cat "$gem_path"
        end
    else
        echo "💀 Gem not found. Available gems:"
        ls ~/ops/gems/ | sed 's/\.md//'
    end
end
