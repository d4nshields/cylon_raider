#!/bin/bash
# check-claude-integration.sh
# Check Claude Code CLI availability and integration status

echo "🔍 Checking Claude Code Integration"
echo "================================"
echo ""

echo "📡 Testing Claude Code CLI availability..."
if command -v claude &> /dev/null; then
    echo "✅ Claude Code CLI is installed"
    version=$(claude --version 2>/dev/null || echo "unknown")
    echo "   Version: $version"
else
    echo "❌ Claude Code CLI is not installed"
    echo "   Run: ./runner-setup/setup-local-runner.sh"
    exit 1
fi

echo ""
echo "🔑 Checking API key configuration..."
if [ -n "$ANTHROPIC_API_KEY" ]; then
    echo "✅ ANTHROPIC_API_KEY is configured"
    echo "   Key length: ${#ANTHROPIC_API_KEY} characters"
else
    echo "⚠️  ANTHROPIC_API_KEY not found in environment"
    echo "   This is normal for local testing"
    echo "   API key will be provided by GitHub Actions"
    echo "   See docs/github-secrets-setup.md for setup instructions"
fi

echo ""
echo "🚀 Cylon Raider is ready for Claude Code development!"
echo ""
echo "To test the complete workflow:"
echo "1. Set up API key: docs/github-secrets-setup.md"
echo "2. Run: gh workflow run cylon-development.yml -f feature_description='test' -f commander_approval='approved'"
