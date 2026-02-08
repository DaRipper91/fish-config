function gpush --description "Push Drive to Cloud"
    echo "⬆️  Pushing to Drive..."
    # --update only copies newer files
    # --exclude protects your bandwidth from big video files
    rclone copy ~/drive gdrive: \
        --exclude "Videos From Backups/**" \
        --exclude "linux-tkg/**" \
        --update -P
    echo "✅ Push Complete."
end
