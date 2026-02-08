function psgrep --description "Find processes"
    ps aux | grep -v grep | grep -i $argv
end