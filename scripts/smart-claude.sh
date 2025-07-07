#!/bin/bash
# smart-claude.sh - Environment-aware Claude execution with proper headless mode
# Uses Claude Code's native headless mode (-p) for CI/CD while preserving reasoning capabilities

set -e

# Check if we should force API mode or headless mode
FORCE_API=false
FORCE_HEADLESS=false
if [ "$1" = "--api" ]; then
    shift
    FORCE_API=true
elif [ "$1" = "--headless" ]; then
    shift
    FORCE_HEADLESS=true
fi

# Check if we're in GitHub Actions or forcing headless mode
if [ -n "$GITHUB_ACTIONS" ] || [ "$FORCE_HEADLESS" = true ]; then
    echo "🤖 Using Claude Code headless mode (non-interactive)"
    
    # Check for API key
    if [ -z "$ANTHROPIC_API_KEY" ]; then
        echo "❌ Error: ANTHROPIC_API_KEY not found"
        echo "   Set with: export ANTHROPIC_API_KEY='your-key-here'"
        exit 1
    fi
    
    # Get the prompt from arguments
    PROMPT="$*"
    
    if [ -z "$PROMPT" ]; then
        echo "❌ Error: No prompt provided"
        exit 1
    fi
    
    # Use Claude Code's native headless mode with forced exit behavior
    echo "🧠 Running Claude Code in headless mode with exit monitoring..."
    
    # Use the force-exit wrapper to ensure proper termination
    if "$(dirname "$0")/claude-force-exit.sh" "$PROMPT"; then
        echo "✅ Claude Code headless execution completed"
    else
        echo "⚠️  Claude Code execution had issues, falling back to API..."
        
        # Fallback to direct API call
        TEMP_RESPONSE=$(mktemp)
        
        curl -s https://api.anthropic.com/v1/messages \
            -H "Authorization: Bearer $ANTHROPIC_API_KEY" \
            -H "Content-Type: application/json" \
            -H "anthropic-version: 2023-06-01" \
            -d "{
                \"model\": \"claude-3-sonnet-20240229\",
                \"max_tokens\": 4000,
                \"messages\": [
                    {
                        \"role\": \"user\",
                        \"content\": $(echo "$PROMPT" | jq -Rs .)
                    }
                ]
            }" > "$TEMP_RESPONSE"
        
        if [ $? -eq 0 ]; then
            RESPONSE_CONTENT=$(jq -r '.content[0].text // empty' "$TEMP_RESPONSE" 2>/dev/null)
            if [ -n "$RESPONSE_CONTENT" ]; then
                echo "✅ API fallback successful"
                # Source the file processor for API responses
                source "$(dirname "$0")/claude-file-processor.sh"
                process_claude_response "$RESPONSE_CONTENT" "."
            else
                echo "❌ API fallback also failed"
                cat "$TEMP_RESPONSE"
            fi
        else
            echo "❌ API fallback failed"
        fi
        
        rm -f "$TEMP_RESPONSE"
    fi
    
elif [ "$FORCE_API" = true ]; then
    echo "🤖 Using direct Anthropic API (forced API mode)"
    
    # Check for API key
    if [ -z "$ANTHROPIC_API_KEY" ]; then
        echo "❌ Error: ANTHROPIC_API_KEY not found"
        echo "   Set with: export ANTHROPIC_API_KEY='your-key-here'"
        exit 1
    fi
    
    # Get the prompt from arguments
    PROMPT="$*"
    
    if [ -z "$PROMPT" ]; then
        echo "❌ Error: No prompt provided"
        exit 1
    fi
    
    # Create a temporary file for the API response
    TEMP_RESPONSE=$(mktemp)
    
    # Make API call to Claude
    echo "📡 Calling Anthropic API..."
    curl -s https://api.anthropic.com/v1/messages \
        -H "Authorization: Bearer $ANTHROPIC_API_KEY" \
        -H "Content-Type: application/json" \
        -H "anthropic-version: 2023-06-01" \
        -d "{
            \"model\": \"claude-3-sonnet-20240229\",
            \"max_tokens\": 4000,
            \"messages\": [
                {
                    \"role\": \"user\",
                    \"content\": $(echo "$PROMPT" | jq -Rs .)
                }
            ]
        }" > "$TEMP_RESPONSE"
    
    # Check if API call was successful
    if [ $? -ne 0 ]; then
        echo "❌ Error: API call failed"
        rm -f "$TEMP_RESPONSE"
        exit 1
    fi
    
    # Extract the response content
    RESPONSE_CONTENT=$(jq -r '.content[0].text // empty' "$TEMP_RESPONSE" 2>/dev/null)
    
    if [ -z "$RESPONSE_CONTENT" ]; then
        echo "❌ Error: No valid response from API"
        echo "API Response:"
        cat "$TEMP_RESPONSE"
        rm -f "$TEMP_RESPONSE"
        exit 1
    fi
    
    # Process the response for file operations
    echo "🧠 Processing Claude's response..."
    
    # Source the file processor
    source "$(dirname "$0")/claude-file-processor.sh"
    
    # Process the response into files
    process_claude_response "$RESPONSE_CONTENT" "."
    
    # Also output the full response for logging
    echo ""
    echo "📝 Claude's full response:"
    echo "$RESPONSE_CONTENT"
    
    # Clean up
    rm -f "$TEMP_RESPONSE"
    
else
    # Local development - use Claude Code CLI interactively
    echo "💻 Using Claude Code CLI (local interactive mode)"
    
    # Check if Claude Code is installed
    if ! command -v claude &> /dev/null; then
        echo "❌ Error: Claude Code CLI not found"
        echo "   Install with: npm install -g @anthropic-ai/claude-code"
        exit 1
    fi
    
    # Check if we have authentication or API key for Claude Code
    if [ ! -d "$HOME/.claude" ] && [ -z "$ANTHROPIC_API_KEY" ]; then
        echo "⚠️  Warning: Claude Code may need authentication"
        echo "   Run 'claude' interactively first to authenticate, or set ANTHROPIC_API_KEY"
        echo ""
        echo "   Alternatives:"
        echo "   - Use headless mode: $0 --headless \"$*\""
        echo "   - Use API mode: $0 --api \"$*\""
    fi
    
    # Pass all arguments to Claude Code CLI
    claude "$@"
fi
