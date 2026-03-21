#!/usr/bin/env bash

# This script sets up the local environment required for Claude Code workflows
set -e

echo "Starting Claude Code Environment Setup..."

# Ensure we are on a compatible system
if ! command -v npm &> /dev/null; then
    echo "npm could not be found. Please install Node.js/npm first."
    exit 1
fi

if ! command -v python3 &> /dev/null; then
    echo "python3 could not be found. Please install Python 3 first."
    exit 1
fi

# Install global NPM packages
echo "Installing global npm tools..."
npm install -g defuddle

# Install local python packages if pip is available
if command -v pip3 &> /dev/null; then
    echo "Installing python tooling..."
    # ruff and pyright are used heavily in python testing/linting workflows
    pip3 install --user ruff pyright
else
    echo "pip3 not found, skipping python tools install."
fi

# Attempt to install GitHub CLI (assuming Fedora/RHEL base from history)
if ! command -v gh &> /dev/null; then
    echo "Installing GitHub CLI (gh)..."
    if command -v dnf &> /dev/null; then
        sudo dnf install -y gh
    elif command -v apt-get &> /dev/null; then
        # fallback for Debian/Ubuntu
        sudo apt-get update
        sudo apt-get install -y gh
    elif command -v brew &> /dev/null; then
        # fallback for Mac/Linuxbrew
        brew install gh
    else
        echo "Could not find a package manager to install gh. Please install manually."
    fi
else
    echo "GitHub CLI is already installed."
fi

echo "========================================="
echo "Setup Complete!"
echo "Note: Make sure your Python bin directory (~/.local/bin) is in your PATH."
echo "If installing 'gh' for the first time, run 'gh auth login' to authenticate."
