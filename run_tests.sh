#!/bin/bash

# Simple test runner for fish scripts

if ! command -v fish >/dev/null 2>&1; then
    echo "❌ Error: 'fish' is not installed. Please install it to run tests."
    exit 1
fi

echo "🚀 Running tests..."

for test_file in test/*.test.fish test/test_*.fish; do
    if [ -f "$test_file" ]; then
        echo ":: Running $test_file"
        fish "$test_file"
        if [ $? -eq 0 ]; then
            echo "✅ $test_file PASSED"
        else
            echo "❌ $test_file FAILED"
            exit 1
        fi
    fi
done

echo "🎉 All tests passed!"
