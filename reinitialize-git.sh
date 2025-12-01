#!/bin/bash

# Script to reinitialize git repository and push to new GitHub account
# This script is safe - it only removes .git folder, not your code files

set -e  # Exit on error

echo "🔄 Reinitializing Git Repository"
echo "=================================="
echo ""

# Get current directory
PROJECT_DIR="/Users/rahil/Downloads/simplecrm_scaffold_google (1)"
cd "$PROJECT_DIR"

# Step 1: Remove existing git repository
echo "📁 Step 1: Removing existing .git folder..."
if [ -d ".git" ]; then
    rm -rf .git
    echo "✅ Old git repository removed"
else
    echo "ℹ️  No existing .git folder found"
fi

# Step 2: Verify files are still there
echo ""
echo "📋 Step 2: Verifying files..."
if [ -d "backend" ] && [ -d "frontend" ]; then
    echo "✅ All project files are present"
else
    echo "❌ Error: Project files not found!"
    exit 1
fi

# Step 3: Initialize new git repository
echo ""
echo "🆕 Step 3: Initializing new git repository..."
git init
echo "✅ New git repository initialized"

# Step 4: Add all files
echo ""
echo "📦 Step 4: Adding all files to git..."
git add .
echo "✅ All files added"

# Step 5: Create initial commit
echo ""
echo "💾 Step 5: Creating initial commit..."
git commit -m "Initial commit - SimpleCRM application"
echo "✅ Initial commit created"

# Step 6: Get GitHub username
echo ""
echo "🔗 Step 6: Setting up remote repository..."
read -p "Enter your NEW GitHub username: " GITHUB_USERNAME
read -p "Enter your repository name (default: simplecrm): " REPO_NAME
REPO_NAME=${REPO_NAME:-simplecrm}

# Step 7: Add remote
echo ""
echo "🌐 Step 7: Adding remote origin..."
REMOTE_URL="https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"
git remote add origin "$REMOTE_URL"
echo "✅ Remote added: $REMOTE_URL"

# Step 8: Rename branch to main
echo ""
echo "🌿 Step 8: Setting branch to main..."
git branch -M main
echo "✅ Branch set to main"

# Step 9: Instructions for pushing
echo ""
echo "🚀 Step 9: Ready to push!"
echo "=================================="
echo ""
echo "📝 Next steps:"
echo "1. Make sure you've created the repository on GitHub:"
echo "   https://github.com/${GITHUB_USERNAME}/${REPO_NAME}"
echo ""
echo "2. Run this command to push:"
echo "   git push -u origin main"
echo ""
echo "3. You'll be prompted for credentials:"
echo "   - Username: ${GITHUB_USERNAME}"
echo "   - Password: Use a Personal Access Token (not your GitHub password)"
echo ""
echo "   To create a token:"
echo "   GitHub → Settings → Developer settings → Personal access tokens"
echo ""
echo "✅ Git repository reinitialized successfully!"
echo ""

