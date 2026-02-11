function da-find --description "Find user-created files in HOME"
    echo "🔍 Scanning HOME for user files (excluding system junk)..."
    # Optimized: Prune hidden directories and node_modules to avoid traversing them
    find $HOME -maxdepth 3 \( -path '*/.*' -o -name 'node_modules' \) -prune -o -type f \( -name "*.md" -o -name "*.txt" -o -name "*.py" -o -name "*.sh" -o -name "*.cfg" -o -name "*.pdf" \) -print
end
