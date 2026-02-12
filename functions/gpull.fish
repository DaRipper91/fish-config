function gpull
    echo "⬇️ Syncing Drive (Skipping: Videos & linux-tkg)..."
    rclone copy gdrive: ~/drive \
        --exclude "Videos From Backups/**" \
        --exclude "linux-tkg/**" \
        --update -P
    echo "✅ Sync Complete."
end
fastfetch
alias sweep="python3 ~/ops/librarian.py"

