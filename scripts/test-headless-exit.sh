#!/bin/bash
# test-headless-exit.sh - Test Claude Code headless mode exit behavior

echo "🧪 Testing Claude Code Headless Mode Exit Behavior"
echo "=================================================="
echo ""

# Check if Claude Code is installed
if ! command -v claude &> /dev/null; then
    echo "❌ Claude Code CLI not found"
    exit 1
fi

# Check for API key
if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo "❌ ANTHROPIC_API_KEY not found"
    echo "   Set with: export ANTHROPIC_API_KEY='your-key-here'"
    exit 1
fi

echo "✅ Prerequisites met"
echo ""

# Test 1: Simple headless mode with timeout
echo "🧪 Test 1: Simple headless command with timeout"
echo "Command: timeout 30 claude -p \"Say hello and exit\""
echo ""

start_time=$(date +%s)
timeout 30 claude -p "Say hello and exit" 2>&1 &
CLAUDE_PID=$!

# Monitor the process
sleep 5
if kill -0 $CLAUDE_PID 2>/dev/null; then
    echo "⚠️  Claude process still running after 5 seconds"
    echo "   This suggests it's waiting for input (entering interactive mode)"
    
    # Try to send EOF to exit
    echo "   Attempting to send EOF..."
    echo "" | timeout 5 tee /proc/$CLAUDE_PID/fd/0 2>/dev/null || true
    
    sleep 2
    if kill -0 $CLAUDE_PID 2>/dev/null; then
        echo "   Still running, force killing..."
        kill -TERM $CLAUDE_PID 2>/dev/null || true
        sleep 1
        kill -KILL $CLAUDE_PID 2>/dev/null || true
    fi
else
    echo "✅ Claude process exited cleanly"
fi

wait $CLAUDE_PID 2>/dev/null
exit_code=$?
end_time=$(date +%s)
duration=$((end_time - start_time))

echo ""
echo "Exit code: $exit_code"
echo "Duration: ${duration}s"
echo ""

# Test 2: Headless mode with explicit non-interactive flag (if available)
echo "🧪 Test 2: Testing alternative flags"
echo "Command: timeout 30 claude -p \"Hello\" --output-format json"
echo ""

start_time=$(date +%s)
timeout 30 claude -p "Hello" --output-format json 2>&1 &
CLAUDE_PID=$!

sleep 5
if kill -0 $CLAUDE_PID 2>/dev/null; then
    echo "⚠️  Still running with --output-format json"
    kill -TERM $CLAUDE_PID 2>/dev/null || true
    sleep 1
    kill -KILL $CLAUDE_PID 2>/dev/null || true
else
    echo "✅ Exited with --output-format json"
fi

wait $CLAUDE_PID 2>/dev/null
exit_code=$?
end_time=$(date +%s)
duration=$((end_time - start_time))

echo ""
echo "Exit code: $exit_code"
echo "Duration: ${duration}s"
echo ""

# Test 3: Check if it's an authentication issue
echo "🧪 Test 3: Authentication check"
echo "Command: claude -p \"Hello\" (no timeout, quick kill)"
echo ""

claude -p "Hello" 2>&1 &
CLAUDE_PID=$!

sleep 3
if kill -0 $CLAUDE_PID 2>/dev/null; then
    # Read what it's outputting
    echo "Process still running, checking output..."
    
    # Get partial output
    sleep 2
    
    if kill -0 $CLAUDE_PID 2>/dev/null; then
        echo "⚠️  Confirmed: Claude Code is not exiting in headless mode"
        echo "   This is likely due to authentication issues or interactive mode fallback"
        kill -TERM $CLAUDE_PID 2>/dev/null || true
        sleep 1
        kill -KILL $CLAUDE_PID 2>/dev/null || true
    fi
else
    echo "✅ Claude exited quickly"
fi

echo ""
echo "📋 Diagnosis:"
echo "============"

if [ $duration -gt 10 ]; then
    echo "❌ ISSUE CONFIRMED: Claude Code headless mode is not exiting properly"
    echo ""
    echo "🔧 Likely causes:"
    echo "1. Authentication issues - Claude Code falls back to interactive mode"
    echo "2. Permission prompts - Tools require interactive approval"
    echo "3. Configuration issues - Headless mode not properly configured"
    echo ""
    echo "🛠️  Recommended solutions:"
    echo "1. Use smart-claude.sh --api for direct API mode"
    echo "2. Pre-configure Claude Code authentication interactively first"
    echo "3. Use --dangerously-skip-permissions flag (if available)"
    echo "4. Fall back to API mode in CI/CD environments"
else
    echo "✅ Claude Code headless mode is working correctly"
    echo "   The issue may be with specific prompts or tools"
fi

echo ""
echo "💡 Workaround: Use smart-claude.sh --api for guaranteed non-interactive execution"
