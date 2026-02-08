function da-arch --wraps g
    set -l sys_prompt "You are Da-Architect. Focus ONLY on system design, file structure, and high-level patterns. Do not write implementation code. Be blunt. Critique the architecture."
    
    # If arguments exist, run one-shot
    if test (count $argv) -gt 0
        g -p "$sys_prompt" $argv
    else
        # Interactive mode with the persona
        g -p "$sys_prompt"
    end
end
