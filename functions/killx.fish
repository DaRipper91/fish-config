function killx
    echo "[-] Nuke protocol initiated..."
    
    # 1. Kill the display server and common desktop managers
    killall -9 Xorg xfce4-session i3 dbus-daemon 2>/dev/null
    
    # 2. Delete the lock files (The most important part)
    # This prevents the "Server already running" error when you try to restart
    rm -rf /tmp/.X11-unix/*
    rm -rf /tmp/.X*-lock
    
    echo "[-] X11 System Down. Clean and ready for restart."
end
