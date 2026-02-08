function da-stats --description "Mesh Resource Intel"
    echo "📊 SYSTEM INTEL: $(hostname)"
    echo "---"
    echo "💾 Disk Usage: $(df -h / | tail -1 | awk '{print $5}')"
    echo "🧠 Memory: $(free -h | grep Mem | awk '{print $3 "/" $2}')"
    echo "🌡️  CPU Load: $(uptime | awk -F'load average:' '{ print $2 }')"
    echo "🌐 Mesh IP: $(tailscale ip -4 2>/dev/null || echo 'Offline')"
end