function sparkle_burst
    set -l colors 39FF14 FF00FF 00FFFF FFFFFF # Green, Magenta, Cyan, White
    for i in (seq 1 20)
        set -l col $colors[(random 1 4)]
        set -l space (string repeat -n (random 1 50) " ")
        set_color $col
        echo -n "$space*"
        if test (math "$i % 5") -eq 0
            echo ""
        end
    end
    set_color normal
    echo ""
end
