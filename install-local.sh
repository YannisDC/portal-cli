#!/bin/bash
# Local installation script for portal
# This installs the tool to Homebrew's bin directory for local testing

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="/opt/homebrew/bin"  # For Apple Silicon Macs
# For Intel Macs, use: TARGET_DIR="/usr/local/bin"

if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Homebrew bin directory not found at $TARGET_DIR"
    echo "Make sure Homebrew is installed and try again"
    exit 1
fi

echo "Installing portal to $TARGET_DIR..."
cp "$SCRIPT_DIR/portal-cli" "$TARGET_DIR/portal"
chmod 0755 "$TARGET_DIR/portal"

# Also create portal-cli symlink for backwards compatibility
if [ -L "$TARGET_DIR/portal-cli" ] || [ -f "$TARGET_DIR/portal-cli" ]; then
    rm "$TARGET_DIR/portal-cli"
fi
ln -s "$TARGET_DIR/portal" "$TARGET_DIR/portal-cli"

echo "✅ portal installed successfully!"
echo "You can now use 'portal' from anywhere"
echo ""
echo "Test it with: portal open --help"
echo "Example: portal open --upstream github.com/YannisDC/upstream-example --version 0.5.0 --lang swift"

