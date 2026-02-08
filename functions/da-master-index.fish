function da-master-index --description "Global Master Index Aggregator"
    set master_file "$HOME/MASTER_INDEX.md"
    echo "🏗️  Synthesizing Master Index..."
    
    if test -f "$master_file"; rm "$master_file"; end
    
    echo "# DA-OMNI-SCOUT: GLOBAL MASTER INDEX" > "$master_file"
    echo "**Node:** $(hostname) | **Arch:** $(uname -m)" >> "$master_file"
    echo "**Generated:** $(date '+%Y-%m-%d %H:%M:%S')" >> "$master_file"
    echo "---" >> "$master_file"
    
    # Summary of Key Hubs
    echo "## 📍 QUICK LINKS" >> "$master_file"
    echo "- [Documents Folder](~/Documents)" >> "$master_file"
    if test -d "$HOME/ops"; echo "- [Ops Infrastructure](~/ops)" >> "$master_file"; end
    if test -d "$HOME/Desktop"; echo "- [Desktop Workspace](~/Desktop)" >> "$master_file"; end
    echo "---" >> "$master_file"

    # Aggregate all local indexes into one view
    find $HOME -maxdepth 4 -name "DIRECTORY_INDEX.md" -not -path '*/.*' | sort | while read -l idx
        set dir_path (dirname $idx)
        set relative_dir (string replace $HOME '~' $dir_path)
        echo "" >> "$master_file"
        echo "### 📂 $relative_dir" >> "$master_file"
        # Pull only the file list from the local index to keep master clean
        grep "^\- \[ \] \*\*" "$idx" >> "$master_file"
    end
    
    echo "✅ MASTER INDEX synthesized from fractal data."
end