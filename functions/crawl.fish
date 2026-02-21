function crawl
    echo "🕷️  Starting Deep Index Crawler (Ignoring Permission Errors)..."
    
    set output_file "MASTER_INDEX.md"
    
    echo "# Device Master Index" > $output_file
    echo "Generated on: "(date) >> $output_file
    echo "Scope: Recursive scan (Newest 50 Files)" >> $output_file
    echo "" >> $output_file

    echo "🔍 Scanning for files..."
    
    # 1. Find newest 50 files, ignoring errors and hidden/node_modules
    # Optimization: Use -prune to skip descending into node_modules and hidden directories
    set files (find . \( -name "node_modules" -o -name ".*" ! -name "." \) -prune -o -type f -printf "%T@ %p\n" 2>/dev/null | sort -nr | cut -d' ' -f2- | head -n 50)

    set context_file "temp_crawl_data.txt"
    echo "START_OF_MANIFEST" > $context_file
    
    for f in $files
        echo "--------------------------------------------------" >> $context_file
        echo "FILE: $f" >> $context_file
        echo "LAST_MODIFIED: "(date -r $f "+%Y-%m-%d") >> $context_file
        echo "--- START OF FIRST 10 LINES ---" >> $context_file
        
        # Read first 10 lines safely
        head -n 10 "$f" 2>/dev/null >> $context_file
        
        echo "--- END OF FIRST 10 LINES ---" >> $context_file
        echo "" >> $context_file
    end
    
    echo "END_OF_MANIFEST" >> $context_file

    echo "🧠 Sending data to Gemini..."

    # 2. Read the context file into a variable, safely
    set file_content (cat $context_file | string collect)
    
    # 3. Construct the prompt
    set prompt "I have provided a file manifest below. For each file, I have included the first 10 lines. 
    
    TASK: Create a Markdown Table with these columns:
    1. **Date** (From the manifest)
    2. **File Name** (The path)
    3. **First 10-Line Summary** (Read the snippet. Write a blunt 1-sentence summary of what this file does.)
    4. **AI Instructions** ('YES' if snippet contains system prompts/rules, else 'No'.)

    DATA:
    $file_content"

    # 4. Send to Gemini
    # We use 'gemini' directly here. If you want logging, change to 'dagem scout "$prompt"'
    # using 'string collect' on the output ensures we capture the markdown table correctly.
    set response (gemini -p "$prompt" 2>/dev/null | string collect)
    
    echo "$response" >> $output_file

    rm $context_file
    echo "✅ Index complete! Saved to: $output_file"
end