function native
    # Kill any hanging native sessions to keep it clean
    killall -9 Xorg xfce4-session 2>/dev/null
    
    # On Arch, PulseAudio is often started automatically. This line might not be necessary.
    # Start audio server
    pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1
    
    # Start X11 on Display :2
    xinit /usr/bin/xfce4-session -- :2 &
    
    echo "[-] Native Desktop Launching on Display :2..."
end
