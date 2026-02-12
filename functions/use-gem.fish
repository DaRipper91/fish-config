function use-gem --description 'Load a Gemini Context Gem'
    set -l gem_name $argv[1]
    set -l gem_base '/home/daripper/.config/gemini-gems'
    set -l target_gem "$gem_base/$gem_name"
    set -l active_context '/tmp/gemini_active_context.md'

    if test -z "$gem_name"
        echo 'Usage: use-gem [name]'
        echo '--- AVAILABLE GEMS ---'
        ls -1 $gem_base
        return 1
    end

    if not test -d "$target_gem"
        echo "❌ Error: Gem '$gem_name' not found in $gem_base"
        return 1
    end

    # Build the System Prompt
    echo '# SYSTEM INSTRUCTION / IDENTITY' > $active_context
    cat "$target_gem/instruction.md" >> $active_context

    if test -f "$target_gem/knowledge.md"
        echo -e "\n\n# EMBEDDED KNOWLEDGE BASE" >> $active_context
        cat "$target_gem/knowledge.md" >> $active_context
    end

    # Set the Environment Variable
    set -gx GEMINI_SYSTEM_MD "$active_context"

    echo "💎 Gem Loaded: $gem_name"
    echo "📂 Context: $active_context"
end
