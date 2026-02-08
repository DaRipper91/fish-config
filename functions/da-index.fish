function da-index --description "Fractal Indexing Engine (Local + Recursive)"
    set target_dir $argv[1]; if test -z "$target_dir"; set target_dir .; end
    set abs_target (realpath $target_dir)

    echo "🌀 Commencing Fractal Scan: $abs_target"

    # Optimized Traversal: Prune hidden and heavy directories
    # Excludes: .hidden, node_modules, build artifacts, and the massive linux-tkg source tree
    find "$abs_target" -type d \( -name ".*" -o -name "node_modules" -o -name "target" -o -name "build" -o -name "dist" -o -name "venv" -o -name "__pycache__" -o -name "linux-tkg" -o -path "*/go/pkg/mod" \) -prune -o -type d -print | while read -l dir
        set index_file "$dir/DIRECTORY_INDEX.md"

        # Get subdirs using ls -p (dirs end with /)
        set subdirs (ls -p "$dir" | grep '/$' | string replace '/' '')

        # Check for files efficiently
        set file_count (find "$dir" -maxdepth 1 -type f -not -name "DIRECTORY_INDEX.md" -not -name ".*" | count)
        set dir_count (count $subdirs)

        if test $file_count -gt 0 -o $dir_count -gt 0
            # Overwrite existing index
            echo "# 📂 INDEX: $(string replace (realpath $HOME) '~' (realpath $dir))" > "$index_file"
            echo "**Scan Date:** $(date '+%Y-%m-%d %H:%M:%S')" >> "$index_file"
            echo "---" >> "$index_file"

            if test $dir_count -gt 0
                echo "## 📁 SUBDIRECTORIES" >> "$index_file"
                for s in $subdirs
                    echo "- [ ] 📂 [$s/](./$s/)" >> "$index_file"
                end
                echo "" >> "$index_file"
            end

            if test $file_count -gt 0
                echo "## 📄 FILES" >> "$index_file"
                # Use find -printf for high-performance listing (Name | Size KB | Date)
                # %f=name, %k=size(KB), %TY-%Tm-%Td=Date
                find "$dir" -maxdepth 1 -type f -not -name "DIRECTORY_INDEX.md" -not -name ".*" -printf "- [ ] **%f** | %k KB | %TY-%Tm-%Td\n" | sort >> "$index_file"
            end
        end
    end
    echo "✅ Fractal Indexing complete."
end
