#!/bin/bash
# claude-headless-test.sh - Test Claude Code headless mode authentication
# This script helps diagnose headless mode issues and provides fallbacks

echo "🧪 Testing Claude Code Headless Mode"
echo "==================================="
echo ""

# Check if Claude Code is installed
if ! command -v claude &> /dev/null; then
    echo "❌ Claude Code CLI not found"
    echo "   Install with: npm install -g @anthropic-ai/claude-code"
    exit 1
fi

echo "✅ Claude Code CLI is installed"
claude_version=$(claude --version 2>/dev/null || echo "unknown")
echo "   Version: $claude_version"
echo ""

# Check for API key
if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo "❌ ANTHROPIC_API_KEY not found"
    echo "   Set with: export ANTHROPIC_API_KEY='your-key-here'"
    exit 1
fi

echo "✅ ANTHROPIC_API_KEY is configured"
echo "   Key length: ${#ANTHROPIC_API_KEY} characters"
echo ""

# Test 1: Basic headless mode
echo "🧪 Test 1: Basic headless mode (-p flag)"
echo "Command: claude -p \"Hello, are you working?\""
echo ""

timeout 30 claude -p "Hello, are you working?" 2>&1 | head -10

test1_exit_code=$?
echo ""
echo "Exit code: $test1_exit_code"
echo ""

if [ $test1_exit_code -eq 0 ]; then
    echo "✅ Test 1 PASSED: Basic headless mode works"
else
    echo "❌ Test 1 FAILED: Basic headless mode has issues"
fi

echo ""
echo "🧪 Test 2: Headless mode with allowed tools"
echo "Command: claude -p \"List files in current directory\" --allowedTools \"Bash\""
echo ""

timeout 30 claude -p "List files in current directory" --allowedTools "Bash" 2>&1 | head -10

test2_exit_code=$?
echo ""
echo "Exit code: $test2_exit_code"
echo ""

if [ $test2_exit_code -eq 0 ]; then
    echo "✅ Test 2 PASSED: Headless mode with tools works"
else
    echo "❌ Test 2 FAILED: Headless mode with tools has issues"
fi

echo ""
echo "🧪 Test 3: File creation in headless mode"
echo "Command: claude -p \"Create a simple hello.txt file\" --allowedTools \"Create,Write\""
echo ""

timeout 30 claude -p "Create a simple hello.txt file with the content 'Hello from Claude Code headless mode'" --allowedTools "Create,Write" 2>&1 | head -10

test3_exit_code=$?
echo ""
echo "Exit code: $test3_exit_code"
echo ""

if [ $test3_exit_code -eq 0 ] && [ -f "hello.txt" ]; then
    echo "✅ Test 3 PASSED: File creation works in headless mode"
    echo "   Created file content:"
    cat hello.txt | head -3
    rm -f hello.txt
else
    echo "❌ Test 3 FAILED: File creation doesn't work in headless mode"
fi

echo ""
echo "📋 Summary:"
echo "=========="

if [ $test1_exit_code -eq 0 ] && [ $test2_exit_code -eq 0 ] && [ $test3_exit_code -eq 0 ]; then
    echo "🎉 ALL TESTS PASSED: Claude Code headless mode is working!"
    echo "   Your GitHub Actions workflows should work correctly."
elif [ $test1_exit_code -eq 0 ]; then
    echo "⚠️  PARTIAL SUCCESS: Basic headless mode works, but tools may have issues"
    echo "   GitHub Actions may work with limited functionality."
else
    echo "❌ HEADLESS MODE FAILURE: Authentication or setup issues detected"
    echo ""
    echo "🔧 Troubleshooting Steps:"
    echo "1. Check authentication: Run 'claude' interactively first"
    echo "2. Verify API key: Ensure it's valid at console.anthropic.com"
    echo "3. Check billing: Ensure account has active billing"
    echo "4. Use fallback: Consider using direct API mode with --api flag"
fi

echo ""
echo "Next steps:"
echo "- If tests pass: Your workflow should work with Claude Code headless mode"
echo "- If tests fail: Use smart-claude.sh --api for direct API fallback"
echo "- For debugging: Check GitHub issue #551 and #1351 for known auth issues"
