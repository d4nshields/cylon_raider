#!/bin/bash
# claude-force-exit.sh - Force Claude Code to exit after completion

# This wrapper script ensures Claude Code exits properly in headless mode
# by monitoring the process and forcing exit when needed

PROMPT="$*"

if [ -z "$PROMPT" ]; then
    echo "Usage: $0 \"your prompt here\""
    exit 1
fi

echo "🤖 Running Claude Code with forced exit behavior"
echo "Prompt: $PROMPT"
echo ""

# Create a temporary file to capture output
OUTPUT_FILE=$(mktemp)
ERROR_FILE=$(mktemp)

# Run Claude Code in background
claude -p "$PROMPT" --allowedTools "Create,Edit,Read,Write,Bash" > "$OUTPUT_FILE" 2> "$ERROR_FILE" &
CLAUDE_PID=$!

echo "Claude PID: $CLAUDE_PID"

# Monitor the process for completion or hanging
TIMEOUT=120
ELAPSED=0
LAST_SIZE=0

while [ $ELAPSED -lt $TIMEOUT ]; do
    if ! kill -0 $CLAUDE_PID 2>/dev/null; then
        # Process has exited
        echo "✅ Claude Code process exited naturally"
        break
    fi
    
    # Check if output is still growing
    CURRENT_SIZE=$(wc -c < "$OUTPUT_FILE" 2>/dev/null || echo 0)
    
    if [ $ELAPSED -gt 10 ] && [ $CURRENT_SIZE -eq $LAST_SIZE ]; then
        # No new output for a while, likely hanging
        echo "⚠️  No output change detected, Claude may be waiting for input"
        echo "   Current output size: $CURRENT_SIZE bytes"
        echo "   Forcing exit..."
        
        # Try graceful termination first
        kill -TERM $CLAUDE_PID 2>/dev/null
        sleep 2
        
        if kill -0 $CLAUDE_PID 2>/dev/null; then
            # Still running, force kill
            echo "   Graceful termination failed, force killing..."
            kill -KILL $CLAUDE_PID 2>/dev/null
        fi
        
        break
    fi
    
    LAST_SIZE=$CURRENT_SIZE
    sleep 2
    ELAPSED=$((ELAPSED + 2))
done

# If still running after timeout, force kill
if kill -0 $CLAUDE_PID 2>/dev/null; then
    echo "❌ Timeout reached, force killing Claude process"
    kill -KILL $CLAUDE_PID 2>/dev/null
fi

# Wait for process to fully exit
wait $CLAUDE_PID 2>/dev/null
EXIT_CODE=$?

echo ""
echo "📄 Output:"
cat "$OUTPUT_FILE"

if [ -s "$ERROR_FILE" ]; then
    echo ""
    echo "⚠️  Errors:"
    cat "$ERROR_FILE"
fi

echo ""
echo "Exit code: $EXIT_CODE"
echo "Total time: ${ELAPSED}s"

# Cleanup
rm -f "$OUTPUT_FILE" "$ERROR_FILE"

echo ""
echo "✅ Claude Code execution completed (forced if necessary)"
