#!/bin/bash
set -e

# Navigate to the directory
cd "$HOME/Projects/fish"

# Initialize Git repository
echo "Initializing Git repository..."
git init
git branch -M main
git add .
git commit -m "Initial commit: Fish shell configuration"

# Create GitHub repository and push
# This creates a PRIVATE repository named 'fish-config' from the current directory
echo "Creating PRIVATE GitHub repository 'fish-config' and pushing..."
gh repo create fish-config --private --source=. --remote=origin --push

echo "----------------------------------------------------------------"
echo "Success! Your fish config is now hosted at: https://github.com/$(gh api user -q .login)/fish-config"
echo "----------------------------------------------------------------"