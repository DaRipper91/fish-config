function da-sync --description "Start Syncthing Mesh"
    if pgrep syncthing > /dev/null
        echo "🔄 Syncthing is already running."
    else
        echo "🚀 Starting Syncthing..."
        syncthing --no-browser &
    end
end