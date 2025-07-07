#!/bin/bash
# test-claude-integration.sh
# Test Claude Code CLI integration

echo "🤖 Testing Claude Code Integration"
echo "=============================="
echo ""

# Test 1: Check Claude Code CLI installation
echo "🔍 Testing Claude Code CLI..."
if command -v claude &> /dev/null; then
    echo "✅ Claude Code CLI is installed"
    claude_version=$(claude --version 2>/dev/null || echo "unknown")
    echo "   Version: $claude_version"
else
    echo "❌ Claude Code CLI not found"
    echo "   Run: ./runner-setup/setup-local-runner.sh"
fi

echo ""

# Test 2: Check API key (without exposing it)
echo "🔑 Testing API Key Configuration..."
if [ -n "$ANTHROPIC_API_KEY" ]; then
    echo "✅ ANTHROPIC_API_KEY environment variable is set"
    echo "   Key length: ${#ANTHROPIC_API_KEY} characters"
    if [[ "$ANTHROPIC_API_KEY" == sk-ant-* ]]; then
        echo "   Format: Looks correct (starts with sk-ant-)"
    else
        echo "   ⚠️  Format: May be incorrect (should start with sk-ant-)"
    fi
else
    echo "❌ ANTHROPIC_API_KEY not found in environment"
    echo "   This should be set automatically in GitHub Actions"
    echo "   For local testing, export ANTHROPIC_API_KEY='your-key-here'"
fi

echo ""

# Test 3: Test Claude Code with simple task (if API key available)
echo "🧪 Testing Claude Code Functionality..."
if [ -n "$ANTHROPIC_API_KEY" ] && command -v claude &> /dev/null; then
    echo "Testing Claude Code with simple file creation task..."
    
    # Create a test directory
    mkdir -p test-claude-output
    cd test-claude-output
    
    # Test Smart Claude with simple task
    timeout 60 ./scripts/smart-claude.sh "
    Create a simple Python hello world script called hello.py.
    The script should print 'Hello from Cylon Raider!' when run.
    Also create a README.md explaining what the script does.
    " 2>/dev/null
    
    # Check results
    if [ -f "hello.py" ] && [ -f "README.md" ]; then
        echo "✅ Claude Code successfully created files:"
        echo "   - hello.py ($(wc -l < hello.py) lines)"
        echo "   - README.md ($(wc -l < README.md) lines)"
        echo ""
        echo "📄 hello.py content preview:"
        head -5 hello.py | sed 's/^/   /'
    else
        echo "❌ Claude Code test failed or timed out"
        echo "   Expected files: hello.py, README.md"
        echo "   Found files: $(ls -la)"
    fi
    
    cd ..
    rm -rf test-claude-output
else
    echo "⏭️  Skipping Claude Code test (API key not available or CLI not installed)"
fi

echo ""
echo "📋 Summary:"
echo "=========="

# Overall assessment
if command -v claude &> /dev/null && [ -n "$ANTHROPIC_API_KEY" ]; then
    echo "✅ Ready for production Cylon Raider workflows!"
    echo "   Claude Code will provide intelligent file system reasoning"
else
    echo "⚠️  Setup required before running Cylon Raider workflows"
    echo "   Run: ./runner-setup/setup-local-runner.sh"
    echo "   Set ANTHROPIC_API_KEY in GitHub repository secrets"
fi

echo ""
echo "Next steps:"
echo "- Set ANTHROPIC_API_KEY in GitHub repository secrets"
echo "- Run: gh workflow run cylon-development.yml -f feature_description='test feature' -f commander_approval='approved'"
