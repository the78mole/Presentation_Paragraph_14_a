#!/bin/bash

# Check if gh is installed
if ! command -v gh &> /dev/null; then
    echo "❌ Error: GitHub CLI (gh) is not installed"
    exit 1
fi

# Check if act extension is installed
if ! gh extension list | grep -q "nektos/gh-act"; then
    echo "⚠️  Error: gh-act extension is not installed"
    read -p "💡 Do you want to install it now? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "📦 Installing gh-act extension..."
        gh extension install nektos/gh-act
        if [ $? -ne 0 ]; then
            echo "❌ Failed to install gh-act extension"
            exit 1
        fi
        echo "✅ gh-act extension installed successfully"
    else
        echo "🚫 Installation cancelled. Please install manually with: gh extension install nektos/gh-act"
        exit 1
    fi
fi

# Run act with pull_request event
echo "🚀 Running act with pull_request event..."
gh act pull_request -e .github/workflows/sim_event_pr42.json --artifact-server-path /tmp/act-artifacts