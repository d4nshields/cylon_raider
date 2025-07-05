#!/bin/bash
# debug-ollama.sh
# Debugging script to check Ollama status and available models

echo "🔍 Ollama Debugging Information"
echo "==============================="
echo ""

# Check if Ollama is installed
echo "📦 Ollama Installation:"
if command -v ollama &> /dev/null; then
    echo "✅ Ollama is installed"
    ollama --version || echo "Could not get version"
else
    echo "❌ Ollama is not installed"
    exit 1
fi
echo ""

# Check if Ollama service is running
echo "🔧 Ollama Service Status:"
if systemctl is-active --quiet ollama 2>/dev/null; then
    echo "✅ Ollama systemd service is running"
elif pgrep -f "ollama serve" >/dev/null; then
    echo "✅ Ollama is running (manual start)"
else
    echo "❌ Ollama is not running"
    echo "Starting Ollama..."
    ollama serve &
    sleep 5
fi
echo ""

# Test API connectivity
echo "🌐 API Connectivity:"
if curl -s http://localhost:11434/api/tags >/dev/null; then
    echo "✅ Ollama API is responding"
else
    echo "❌ Ollama API is not responding"
    echo "Attempting to start Ollama manually..."
    pkill -f "ollama serve" 2>/dev/null
    ollama serve &
    sleep 10
    if curl -s http://localhost:11434/api/tags >/dev/null; then
        echo "✅ Ollama API is now responding"
    else
        echo "❌ Still cannot reach Ollama API"
        exit 1
    fi
fi
echo ""

# List currently installed models
echo "📚 Currently Installed Models:"
ollama list || echo "Could not list models"
echo ""

# Try to pull a simple model to test
echo "🧪 Testing Model Download:"
echo "Attempting to pull llama3.2:1b (smallest model)..."
if ollama pull llama3.2:1b; then
    echo "✅ Successfully downloaded test model"
    
    # Test the model
    echo "Testing model inference..."
    response=$(timeout 30 ollama run llama3.2:1b "Say 'test successful'" 2>&1)
    if [[ "$response" == *"test successful"* ]] || [[ "$response" == *"successful"* ]]; then
        echo "✅ Model inference working"
    else
        echo "⚠️  Model response: $response"
    fi
else
    echo "❌ Failed to download test model"
    echo "Checking what models are available..."
    curl -s "https://ollama.com/api/tags" | jq -r '.models[].name' | head -10 || echo "Could not fetch available models"
fi

echo ""
echo "🔗 Useful Commands:"
echo "- Check service: systemctl status ollama"
echo "- Restart service: sudo systemctl restart ollama"
echo "- Manual start: ollama serve"
echo "- List models: ollama list"
echo "- Test API: curl http://localhost:11434/api/tags"
