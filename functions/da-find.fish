function da-find --description "Find user-created files in HOME"
    echo "🔍 Scanning HOME for user files (excluding system junk)..."
    find $HOME -maxdepth 3 -not -path '*/.*' -type f \( -name "*.md" -o -name "*.txt" -o -name "*.py" -o -name "*.sh" -o -name "*.cfg" -o -name "*.pdf" \) | grep -v "node_modules"
end