function fish_postexec
    # Check if the last command failed (status code not 0)
    if test $status -ne 0
        echo
        set -l gemi_red FF0000
        set -l gemi_yellow FFFF00
        set -l gemi_gray 555555
        
        # An industrial "shrapnel" burst
        set_color -o $gemi_red
        echo " [!] SYSTEM_ERROR: EXECUTION_FAILURE"
        
        for i in (seq 1 15)
            set -l col (random choice $gemi_red $gemi_yellow $gemi_gray)
            set -l dash (string repeat -n (random 1 40) " ")
            set_color $col
            echo -s $dash "!"
        end
        
        set_color normal
        echo " [?] Verify syntax or permissions, Cody. This is a mess."
        echo
    end
end
