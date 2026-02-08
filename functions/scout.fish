function scout
    set cmd_name $argv[1]
    if type -q $cmd_name
        set raw_intel ($cmd_name --help 2>&1); if test $status -ne 0; set raw_intel (man $cmd_name | col -b); end
        dagem scout "Generate 8-5-4 Manual for $cmd_name. RAW DATA: $raw_intel"
    else; echo "❌ Target $cmd_name not found."; end
end