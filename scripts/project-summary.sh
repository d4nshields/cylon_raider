#!/bin/bash
# project-summary.sh
# Shows a summary of the Cylon Raider project structure

echo "🤖 Cylon Raider Project Summary"
echo "==============================="
echo ""

echo "📁 Project Structure:"
echo "├── 🏠 Root Configuration"
echo "│   ├── README.md                 # Main project documentation"
echo "│   ├── .gitignore               # Git ignore patterns"
echo "│   └── .github/workflows/       # GitHub Actions workflows"
echo "│"
echo "├── 🎯 System Prompts"
echo "│   ├── commander.md             # Strategic oversight role"
echo "│   ├── pilot.md                 # Architecture & planning role" 
echo "│   └── gunner.md                # Implementation & testing role"
echo "│"
echo "├── 🛠️ Runner Setup"
echo "│   ├── setup-local-runner.sh    # Local machine setup"
echo "│   ├── setup-cloud-runner.sh    # Cloud VM setup"
echo "│   └── setup-oracle-runner.sh   # Oracle Cloud free tier"
echo "│"
echo "├── 📚 Documentation"
echo "│   └── runner-setup.md          # Comprehensive setup guide"
echo "│"
echo "├── 🔧 Utility Scripts"
echo "│   ├── test-cylon-roles.sh      # Test AI role functionality"
echo "│   └── monitor-runner.sh        # Monitor system health"
echo "│"
echo "└── 📝 Examples"
echo "    └── calculator.md            # Sample project walkthrough"
echo ""

echo "🎯 Core Concept:"
echo "Three-role AI development team with human oversight:"
echo "• Commander (Human): Strategic decisions, quality gates"
echo "• Pilot (AI): Architecture design, technical planning"  
echo "• Gunner (AI): Code implementation, testing"
echo ""

echo "🏗️ Architecture:"
echo "• Self-hosted GitHub Actions runners"
echo "• Local Ollama AI models"
echo "• Three-workspace git branching"
echo "• Two-stage quality review process"
echo ""

echo "🚀 Quick Start:"
echo "1. Choose your setup:"
echo "   • Local: ./runner-setup/setup-local-runner.sh"
echo "   • Cloud: ./runner-setup/setup-cloud-runner.sh"
echo "   • Oracle: ./runner-setup/setup-oracle-runner.sh"
echo ""
echo "2. Configure GitHub runner (follow setup script instructions)"
echo ""
echo "3. Test your setup:"
echo "   ./scripts/test-cylon-roles.sh"
echo ""
echo "4. Run your first mission:"
echo "   gh workflow run cylon-development.yml \\"
echo "     -f feature_description=\"Build a simple calculator\""
echo ""

echo "💡 Key Benefits:"
echo "• No cloud provider dependency or capacity limits"
echo "• Complete control over AI compute resources"
echo "• Model persistence (no re-downloading)"
echo "• Cost flexibility (free to enterprise)"
echo "• Reproducible development methodology"
echo ""

echo "📊 System Requirements:"
echo "Minimum: 8GB RAM, 2 CPU cores, 20GB disk"
echo "Recommended: 16GB RAM, 4 CPU cores, 50GB disk"
echo "Optimal: 24GB+ RAM, 8+ CPU cores, 100GB+ disk"
echo ""

echo "🎮 Available Commands:"
if [ -f "./scripts/test-cylon-roles.sh" ]; then
    echo "✅ ./scripts/test-cylon-roles.sh     # Test AI functionality"
else
    echo "❌ ./scripts/test-cylon-roles.sh     # Not found"
fi

if [ -f "./scripts/monitor-runner.sh" ]; then
    echo "✅ ./scripts/monitor-runner.sh       # Monitor system health"
else
    echo "❌ ./scripts/monitor-runner.sh       # Not found"
fi

echo ""

# Check current system status
echo "🔍 Current System Status:"

# Check if Ollama is installed
if command -v ollama &> /dev/null; then
    echo "✅ Ollama: Installed"
    if curl -s http://localhost:11434/api/tags >/dev/null 2>&1; then
        model_count=$(ollama list 2>/dev/null | tail -n +2 | wc -l)
        echo "✅ Ollama API: Responding ($model_count models)"
    else
        echo "⚠️  Ollama API: Not responding"
    fi
else
    echo "❌ Ollama: Not installed"
fi

# Check if Docker is installed
if command -v docker &> /dev/null; then
    echo "✅ Docker: Installed"
else
    echo "❌ Docker: Not installed"
fi

# Check for GitHub CLI
if command -v gh &> /dev/null; then
    echo "✅ GitHub CLI: Installed"
else
    echo "⚠️  GitHub CLI: Not installed (optional)"
fi

# Check for active runners
if pgrep -f "actions-runner" >/dev/null; then
    echo "✅ GitHub Runner: Active"
else
    echo "❌ GitHub Runner: Not running"
fi

echo ""
echo "📖 Next Steps:"
if ! command -v ollama &> /dev/null; then
    echo "1. Run setup script for your environment"
elif ! curl -s http://localhost:11434/api/tags >/dev/null 2>&1; then
    echo "1. Start Ollama service: systemctl start ollama"
elif ! pgrep -f "actions-runner" >/dev/null; then
    echo "1. Configure and start GitHub Actions runner"
else
    echo "1. System ready! Try running a workflow"
fi

echo "2. Read documentation: docs/runner-setup.md"
echo "3. Try examples: examples/calculator.md"
echo ""

echo "🌟 Philosophy:"
echo "\"Disciplined AI collaboration through clear role boundaries,"
echo " quality gates, and human strategic oversight.\""
echo ""
echo "🔗 Learn more: https://github.com/yourusername/cylon_raider"
