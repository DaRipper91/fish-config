# Test for crawl.fish

# Helper: Mock gemini function to capture output
function gemini
    echo "MOCK_GEMINI_OUTPUT: $argv"
end

# Resolve function path before changing directory
set -l func_path $PWD/functions/crawl.fish
if not test -f $func_path
    echo "❌ Cannot find functions/crawl.fish at $func_path"
    exit 1
end

# Setup temporary directory
set -l temp_dir (mktemp -d)
# echo "Running test in $temp_dir"

# Navigate to temp dir
pushd $temp_dir

# Create test files
mkdir -p src
touch src/main.js
touch src/style.css
mkdir -p node_modules/pkg
touch node_modules/pkg/index.js
touch .env
mkdir -p .git
touch .git/config

# Source the function
source $func_path

# Run crawl (redirect output to avoid spam)
crawl >/dev/null

# Check output file exists
if not test -f MASTER_INDEX.md
    echo "❌ MASTER_INDEX.md not created"
    popd
    rm -rf $temp_dir
    exit 1
end

# Read output content
set -l content (cat MASTER_INDEX.md)

# Verify included files
if not string match -q "*src/main.js*" $content
    echo "❌ src/main.js missing from output"
    popd
    rm -rf $temp_dir
    exit 1
end

if not string match -q "*src/style.css*" $content
    echo "❌ src/style.css missing from output"
    popd
    rm -rf $temp_dir
    exit 1
end

# Verify excluded files (node_modules)
if string match -q "*node_modules/pkg/index.js*" $content
    echo "❌ node_modules/pkg/index.js should be excluded"
    popd
    rm -rf $temp_dir
    exit 1
end

# Verify excluded files (hidden file)
# Note: we search for the specific filename pattern as it appears in the manifest
if string match -q "*FILE: ./.env*" $content
    echo "❌ .env (hidden file) should be excluded"
    popd
    rm -rf $temp_dir
    exit 1
end

# Verify excluded files (hidden directory file)
if string match -q "*FILE: ./.git/config*" $content
    echo "❌ .git/config (file in hidden dir) should be excluded"
    popd
    rm -rf $temp_dir
    exit 1
end

echo "✅ crawl.fish Logic Verified"

# Cleanup
popd
rm -rf $temp_dir
