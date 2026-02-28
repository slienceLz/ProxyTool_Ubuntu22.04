#!/bin/bash

# Install script for Proxy Tool
# Appends source command to user's .bashrc or .zshrc

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROXY_TOOL_PATH="$SCRIPT_DIR/proxy_tool.sh"

echo "Installing Proxy Tool..."

SHELL_CONFIG=""
if [[ "$SHELL" == *"zsh"* ]]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [[ "$SHELL" == *"bash"* ]]; then
    SHELL_CONFIG="$HOME/.bashrc"
else
    # Fallback to .bashrc if shell detection fails or is unknown
    SHELL_CONFIG="$HOME/.bashrc"
    echo "Warning: Could not detect shell. Defaulting to .bashrc"
fi

if grep -q "source $PROXY_TOOL_PATH" "$SHELL_CONFIG"; then
    echo "Proxy Tool is already installed in $SHELL_CONFIG"
else
    echo "" >> "$SHELL_CONFIG"
    echo "# Proxy Tool" >> "$SHELL_CONFIG"
    echo "source $PROXY_TOOL_PATH" >> "$SHELL_CONFIG"
    echo "Added to $SHELL_CONFIG"
fi

echo "Installation complete!"
echo "Please run the following command to apply changes:"
echo "  source $SHELL_CONFIG"
echo ""
echo "Then you can use the 'proxy' command."
