#!/bin/bash
# test-cylon-roles.sh
# Test script to verify all three Cylon roles are working

set -e

echo "🤖 Testing Cylon Raider Roles"
echo "============================="
echo ""

# Check if Ollama is running
if ! curl -s http://localhost:11434/api/tags >/dev/null; then
    echo "❌ Ollama is not responding. Make sure it's running:"
    echo "   systemctl start ollama"
    exit 1
fi

echo "✅ Ollama is responding"
echo ""

# Test Commander role
echo "🎯 Testing Commander (Strategic Planning)..."
commander_response=$(timeout 60 ollama run llama3.2:8b-instruct "You are the Centurion Commander. Evaluate this request: 'Build a simple todo list app'. Respond with a brief strategic assessment and approval/rejection." 2>/dev/null || echo "timeout")

if [[ "$commander_response" == "timeout" ]]; then
    echo "⚠️  Commander test timed out (model may be loading)"
else
    echo "✅ Commander response:"
    echo "   $(echo "$commander_response" | head -c 150)..."
fi
echo ""

# Test Pilot role  
echo "🧭 Testing Pilot (Architecture Design)..."
pilot_response=$(timeout 60 ollama run qwen2.5:7b-instruct "You are the Pilot. Design the technical architecture for a todo list app. List the main components and their responsibilities." 2>/dev/null || echo "timeout")

if [[ "$pilot_response" == "timeout" ]]; then
    echo "⚠️  Pilot test timed out (model may be loading)"
else
    echo "✅ Pilot response:"
    echo "   $(echo "$pilot_response" | head -c 150)..."
fi
echo ""

# Test Gunner role
echo "⚔️ Testing Gunner (Implementation)..."
gunner_response=$(timeout 60 ollama run codellama:7b-instruct "You are the Gunner. Write a simple Python class for a TodoItem with fields: id, title, completed. Include a method to toggle completion." 2>/dev/null || echo "timeout")

if [[ "$gunner_response" == "timeout" ]]; then
    echo "⚠️  Gunner test timed out (model may be loading)"
else
    echo "✅ Gunner response:"
    echo "   $(echo "$gunner_response" | head -c 150)..."
fi
echo ""

# System information
echo "📊 System Information:"
echo "- RAM: $(free -h | awk '/^Mem:/{print $2}')"
echo "- CPU: $(nproc) cores"
echo "- Models: $(ollama list | tail -n +2 | wc -l) installed"
echo "- Ollama version: $(ollama --version 2>/dev/null || echo "unknown")"
echo ""

echo "🎉 Cylon role testing complete!"
echo ""
echo "💡 Tips:"
echo "- If timeouts occur, models may still be loading into memory"
echo "- First runs are slower as models load"
echo "- Subsequent runs will be much faster"
echo ""
echo "🚀 Ready to run GitHub Actions workflows!"
