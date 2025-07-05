#!/bin/bash
# start-cylon-services.sh
# Starts all Cylon Raider services

set -e

echo "🚀 Starting Cylon Raider Services"
echo "================================"

# Reload systemd and start services
sudo systemctl daemon-reload

# Enable and start the API service
sudo systemctl enable cylon-api.service
sudo systemctl start cylon-api.service

# Wait a moment for services to start
sleep 5

# Check service status
echo ""
echo "📊 Service Status:"
echo "=================="

echo "Ollama Service:"
sudo systemctl status ollama --no-pager -l | grep -E "(Active|Main PID|Tasks)"

echo ""
echo "Cylon API Service:"
sudo systemctl status cylon-api --no-pager -l | grep -E "(Active|Main PID|Tasks)"

# Test the services
echo ""
echo "🧪 Testing Services:"
echo "==================="

# Test Ollama
echo "Testing Ollama..."
if curl -s http://localhost:11434/api/tags > /dev/null; then
    echo "✅ Ollama is responding"
else
    echo "❌ Ollama is not responding"
fi

# Test Cylon API
echo "Testing Cylon API..."
if curl -s http://localhost:8080/health > /dev/null; then
    echo "✅ Cylon API is responding"
    curl -s http://localhost:8080/health | python3 -m json.tool
else
    echo "❌ Cylon API is not responding"
fi

echo ""
echo "🎉 Cylon Raider services are running!"
echo ""
echo "Access points:"
echo "- Ollama API: http://localhost:11434"
echo "- Cylon API: http://localhost:8080"
echo "- Health check: http://localhost:8080/health"
echo ""
echo "Role endpoints:"
echo "- Commander: POST http://localhost:8080/commander"
echo "- Pilot: POST http://localhost:8080/pilot" 
echo "- Gunner: POST http://localhost:8080/gunner"
echo ""
echo "Example usage:"
echo 'curl -X POST http://localhost:8080/pilot -H "Content-Type: application/json" -d '"'"'{"prompt": "Design a user authentication system"}'"'"''
