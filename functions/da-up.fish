function da-up --description "Upload Global User Files to GDrive"
    echo "☁️  Syncing discovered User Files to Google Drive..."
    # First sync the ops folder
    rclone sync ~/ops/ gdrive:OpsArchive/ops --progress
    # Then sync specific user-identified high-value folders
    rclone sync ~/Documents/ gdrive:OpsArchive/Documents --progress --exclude ".*/**"
end