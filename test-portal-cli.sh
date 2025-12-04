#!/bin/bash
# Test script for portal-cli

set -e

echo "🧪 Testing portal-cli locally..."
echo ""

# Test 1: Help command
echo "Test 1: Testing --help flag"
./portal-cli open --help > /dev/null && echo "✅ Help command works" || echo "❌ Help command failed"
echo ""

# Test 2: Test with a small public repository
echo "Test 2: Creating a test portal project"
TEST_REPO="github.com/octocat/Hello-World"
TEST_LANG="python"
TEST_DIR="portal-Hello-World"

# Clean up if test directory exists
if [ -d "$TEST_DIR" ]; then
    echo "Cleaning up previous test directory..."
    rm -rf "$TEST_DIR"
fi

# Run the tool
echo "Running: ./portal-cli open --upstream $TEST_REPO --lang $TEST_LANG"
./portal-cli open --upstream "$TEST_REPO" --lang "$TEST_LANG"

# Verify structure
if [ -d "$TEST_DIR" ] && [ -d "$TEST_DIR/upstream" ] && [ -d "$TEST_DIR/python-port" ]; then
    echo "✅ Project structure created correctly"
    echo "   - Main directory: $TEST_DIR"
    echo "   - Upstream directory: $TEST_DIR/upstream"
    echo "   - Port directory: $TEST_DIR/python-port"
else
    echo "❌ Project structure is incorrect"
    exit 1
fi

# Clean up
echo ""
echo "Cleaning up test directory..."
rm -rf "$TEST_DIR"
echo "✅ Test completed successfully!"

