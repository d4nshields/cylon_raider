#!/bin/bash
# check-available-models.sh
# Check what models are actually available in Ollama

echo "🔍 Checking Available Ollama Models"
echo "==================================="
echo ""

echo "📡 Testing Ollama API connectivity..."
if curl -s http://localhost:11434/api/tags >/dev/null; then
    echo "✅ Ollama API is responding"
else
    echo "❌ Ollama API is not responding"
    exit 1
fi

echo ""
echo "📋 Currently installed models:"
ollama list

echo ""
echo "🔍 Checking specific model availability..."

# Test common model names
models_to_check=(
    "llama3.2"
    "llama3.2:8b"
    "llama3.2:8b-instruct"
    "llama3.2:latest"
    "qwen2.5"
    "qwen2.5:7b"
    "qwen2.5:7b-instruct" 
    "qwen2.5:latest"
    "codellama"
    "codellama:7b"
    "codellama:7b-instruct"
    "codellama:latest"
    "llama3"
    "llama3:8b"
    "llama3:8b-instruct"
)

echo "Testing model name variations..."
for model in "${models_to_check[@]}"; do
    echo -n "Testing $model... "
    if timeout 10 ollama show "$model" >/dev/null 2>&1; then
        echo "✅ Available"
    else
        echo "❌ Not found"
    fi
done

echo ""
echo "🌐 Popular models from Ollama library:"
echo "You can check https://ollama.com/library for the full list"
echo ""
echo "Try downloading one of these confirmed working models:"
echo "- ollama pull llama3.2"
echo "- ollama pull qwen2.5"  
echo "- ollama pull codellama"
