function fish_greeting
    # ------------------------------------------------------------------
    # CONFIGURATION: DaRipper FABRIC + SPARKLE MODE
    # Smaller bold font with thematic surrounding sparkles.
    # ------------------------------------------------------------------
    
    set rng (random 1 5)
    echo

    # Define Sparkle Characters
    set s1 "*"
    set s2 "+"
    set s3 "°"
    set s4 "."

    switch $rng
        # --------------------------------------------------------------
        # CASE 1: SPACE BLOBS (Img 3903: Pink -> Cyan -> Orange)
        # --------------------------------------------------------------
        case 1
            set c_top FF0066 # Neon Pink
            set c_mid 00FFCC # Cyan
            set c_low FF9900 # Deep Orange
            set c_star FFFF00 # Yellow stars
            
            echo -s (set_color $c_star) "  $s1 " (set_color -o $c_top) "    ____        ____  _" (set_color $c_star) " $s2"
            echo -s (set_color $c_star) "$s4   " (set_color -o $c_top) "   / __ \____ _/ __ \(_)___  ____  ___  _____" (set_color $c_star) " $s3"
            echo -s (set_color $c_star) " $s2  " (set_color -o $c_mid) "  / / / / __ `/ /_/ / / __ \/ __ \/ _ \/ ___/" (set_color $c_star) "$s1"
            echo -s (set_color $c_star) "   $s3" (set_color -o $c_mid) " / /_/ / /_/ / _, _/ / /_/ / /_/ /  __/ /" (set_color $c_star) "  $s4"
            echo -s (set_color $c_star) "$s1    " (set_color -o $c_low) "/_____/\__,_/_/ |_/_/ .___/ .___/\___/_/" (set_color $c_star) " $s2"
            echo -s (set_color -o $c_low) "                       /_/   /_/"
            set_color -o $c_top; echo "   >> STYLE: DEEP_SPACE_SPARKLE"

        # --------------------------------------------------------------
        # CASE 2: PAISLEY CHAOS (Img 3904: HotPink, SkyBlue, Gold)
        # --------------------------------------------------------------
        case 2
            set c1 FF69B4 # HotPink
            set c2 87CEEB # SkyBlue
            set c3 FFD700 # Gold

            echo -s (set_color $c1)" $s2 "(set_color -o $c1)"    ____" (set_color -o $c2)"        ____  _" (set_color $c3)" $s1"
            echo -s (set_color $c2)"$s3  "(set_color -o $c2)"   / __ \____ _" (set_color -o $c3)"/ __ \(_)___" (set_color -o $c1)"  ____  ___  _____" (set_color $c2)" $s4"
            echo -s (set_color $c3)" $s1 "(set_color -o $c3)"  / / / / __ `" (set_color -o $c1)"/ /_/ / / __ \\" (set_color -o $c2)"/ __ \/ _ \/ ___/" (set_color $c1)"$s2"
            echo -s (set_color $c1)"  $s4"(set_color -o $c1)" / /_/ / /_/ /" (set_color -o $c2)" _, _/ / /_/ /" (set_color -o $c3)" /_/ /  __/ /" (set_color $c2)" $s1"
            echo -s (set_color $c2)"$s2  "(set_color -o $c2)"/_____/\__,_/_/" (set_color -o $c3)" |_/_/ .___/" (set_color -o $c1)" .___/\___/_/" (set_color $c3)"$s3 "
            echo -s (set_color -o $c3)"                   /_/   /_/"
            echo "   >> STYLE: PAISLEY_CHAOS"

        # --------------------------------------------------------------
        # CASE 3: RETRO WAVES (Img 3902: Turquoise, Lime, Magenta, Orange)
        # --------------------------------------------------------------
        case 3
            set b1 00CED1; set b2 ADFF2F; set b3 FF00FF #
            set b4 FFA500; set b5 9400D3; set b6 FFFF00 #

            echo -s (set_color $b1) "$s3  " (set_color -o $b1) "    ____        ____  _" (set_color $b1) " $s4"
            echo -s (set_color $b2) " $s4 " (set_color -o $b2) "   / __ \____ _/ __ \(_)___  ____  ___  _____" (set_color $b2) "$s3"
            echo -s (set_color $b3) "$s3  " (set_color -o $b3) "  / / / / __ `/ /_/ / / __ \/ __ \/ _ \/ ___/" (set_color $b3) " $s4"
            echo -s (set_color $b4) " $s4 " (set_color -o $b4) " / /_/ / /_/ / _, _/ / /_/ / /_/ /  __/ /" (set_color $b4) "  $s3"
            echo -s (set_color $b5) "$s3  " (set_color -o $b5) "/_____/\__,_/_/ |_/_/ .___/ .___/\___/_/" (set_color $b5) "$s4"
            echo -s (set_color -o $b6) "                       /_/   /_/"
            echo "   >> STYLE: RETRO_WAVES"

        # --------------------------------------------------------------
        # CASE 4: SPLATTER (Img 3906: Solid White Text + Neon Sparkles)
        # --------------------------------------------------------------
        case 4
            set c_ink1 FF00FF # Magenta
            set c_ink2 00FFFF # Cyan
            set c_base FFFFFF # Solid Bold White

            echo -s (set_color $c_ink1)" $s1 " (set_color -o $c_base) "    ____        ____  _" (set_color $c_ink2) "  $s3"
            echo -s (set_color $c_ink2)"$s4  " (set_color -o $c_base) "   / __ \____ _/ __ \(_)___  ____  ___  _____" (set_color $c_ink1) " $s1 "
            echo -s (set_color $c_ink1)" $s2 " (set_color -o $c_base) "  / / / / __ `/ /_/ / / __ \/ __ \/ _ \/ ___/" (set_color $c_ink2) "$s4"
            echo -s (set_color $c_ink2)"  $s3" (set_color -o $c_base) " / /_/ / /_/ / _, _/ / /_/ / /_/ /  __/ /" (set_color $c_ink1) " $s2"
            echo -s (set_color $c_ink1)"$s1  " (set_color -o $c_base) "/_____/\__,_/_/ |_/_/ .___/ .___/\___/_/" (set_color $c_ink2) "   $s1"
            echo -s (set_color -o $c_base) "                       /_/   /_/"
            set_color -o $c_ink1; echo "   >> STYLE: CLEAN_SPLATTER"

        # --------------------------------------------------------------
        # CASE 5: GOTHIC BATS (Img 3905: Indigo + Neon Green)
        # --------------------------------------------------------------
        case 5
            set c_night 4B0082 # Indigo
            set c_glow  39FF14 # Neon Green

            echo -s (set_color $c_glow)" $s3 " (set_color -o $c_night) "    ____        ____  _" (set_color $c_glow) " $s1"
            echo -s (set_color $c_glow)"$s1  " (set_color -o $c_night) "   / __ \____ _/ __ \(_)___  ____  ___  _____" (set_color $c_glow) "  $s3"
            echo -s (set_color $c_glow)"  $s3" (set_color -o $c_night) "  / / / / __ `/ /_/ / / __ \/ __ \/ _ \/ ___/" (set_color $c_glow) "$s1"
            echo -s (set_color $c_glow)"$s1  " (set_color -o $c_night) " / /_/ / /_/ / " (set_color -o $c_glow)"_, _" (set_color -o $c_night)" / /_/ / /_/ /  __/ /" (set_color $c_glow) " $s3"
            echo -s (set_color $c_glow)" $s3 " (set_color -o $c_night) "/_____/\__,_/_/ |_/_/ " (set_color -o $c_glow)".___" (set_color -o $c_night)"/ " (set_color -o $c_glow)".___" (set_color -o $c_night)"/\___/_/" (set_color $c_glow) "$s1 "
            echo -s (set_color -o $c_night) "                       /_/   /_/"
            set_color -o $c_glow; echo "   >> STYLE: GOTHIC_BATS"
    end

    set_color normal; echo
end
