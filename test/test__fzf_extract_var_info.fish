source functions/_fzf_extract_var_info.fish

# Helper to run a test case
function test_extract_var_info --argument-names variable_name input_content expected_output
    set -l temp_file (mktemp)
    printf "%s" "$input_content" >$temp_file

    set -l actual_output (_fzf_extract_var_info $variable_name $temp_file)
    set -l exit_status $status

    rm $temp_file

    # Use string join to handle multi-line comparison correctly
    set -l joined_actual (string join "\n" $actual_output)

    if test "$joined_actual" = "$expected_output"
        echo "✅ PASS: $variable_name"
        return 0
    else
        echo "❌ FAIL: $variable_name"
        echo "  Expected:"
        printf "%s\n" "$expected_output"
        echo "  Got:"
        printf "%s\n" "$joined_actual"
        return 1
    end
end

set -l exit_code 0

echo "🧪 Testing _fzf_extract_var_info..."

# Case 1: Multi-value variable
set -l input_1 "\$PATH: set in global scope, unexported, with 3 elements\n\$PATH[1]: |/usr/local/bin|\n\$PATH[2]: |/usr/bin|\n\$PATH[3]: |/bin|"
set -l expected_1 "set in global scope, unexported, with 3 elements\n[1] /usr/local/bin\n[2] /usr/bin\n[3] /bin"
test_extract_var_info "PATH" $input_1 $expected_1; or set exit_code 1

# Case 2: Variable name prefixing (VAR vs VAR_LONG)
set -l input_2 "\$VAR: set in global scope...\n\$VAR[1]: |val|\n\$VAR_LONG: set in global scope...\n\$VAR_LONG[1]: |long_val|"
set -l expected_2 "set in global scope...\n[1] val"
test_extract_var_info "VAR" $input_2 $expected_2; or set exit_code 1

# Case 3: Special characters (pipes and colons)
set -l input_3 "\$SPECIAL: scope info\n\$SPECIAL[1]: |value with | pipes|\n\$SPECIAL[2]: |value with : colons|"
set -l expected_3 "scope info\n[1] value with | pipes\n[2] value with : colons"
test_extract_var_info "SPECIAL" $input_3 $expected_3; or set exit_code 1

# Case 4: Single value
set -l input_4 "\$EDITOR: set in global scope...\n\$EDITOR[1]: |vim|"
set -l expected_4 "set in global scope...\n[1] vim"
test_extract_var_info "EDITOR" $input_4 $expected_4; or set exit_code 1

exit $exit_code
