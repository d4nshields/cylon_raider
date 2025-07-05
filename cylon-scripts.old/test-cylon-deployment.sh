#!/bin/bash
# test-cylon-deployment.sh
# Comprehensive testing script for Cylon Raider deployment

set -e

echo "🧪 Cylon Raider Deployment Test Suite"
echo "====================================="

VM_IP=${1:-"localhost"}
BASE_URL="http://$VM_IP:8080"

echo "Testing against: $BASE_URL"
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test function
test_endpoint() {
    local name=$1
    local endpoint=$2
    local data=$3
    
    echo -n "Testing $name... "
    
    if response=$(curl -s -X POST "$BASE_URL$endpoint" \
        -H "Content-Type: application/json" \
        -d "$data" \
        --max-time 60); then
        
        if echo "$response" | jq -e '.response' > /dev/null 2>&1; then
            echo -e "${GREEN}✅ PASS${NC}"
            echo "   Response preview: $(echo "$response" | jq -r '.response' | head -c 100)..."
            echo "   Model: $(echo "$response" | jq -r '.model')"
            echo "   Execution time: $(echo "$response" | jq -r '.execution_time')s"
        else
            echo -e "${RED}❌ FAIL - Invalid response format${NC}"
            echo "   Response: $response"
        fi
    else
        echo -e "${RED}❌ FAIL - No response${NC}"
    fi
    echo ""
}

# Health check first
echo "🏥 Health Check"
echo "==============="
if health_response=$(curl -s "$BASE_URL/health" --max-time 10); then
    echo -e "${GREEN}✅ API is responding${NC}"
    echo "$health_response" | jq .
    
    ollama_status=$(echo "$health_response" | jq -r '.ollama')
    if [ "$ollama_status" = "healthy" ]; then
        echo -e "${GREEN}✅ Ollama is healthy${NC}"
    else
        echo -e "${YELLOW}⚠️  Ollama status: $ollama_status${NC}"
    fi
else
    echo -e "${RED}❌ API health check failed${NC}"
    exit 1
fi
echo ""

# Test each role
echo "🎯 Testing Commander Role"
echo "========================="
test_endpoint "Commander Strategy" "/commander" '{
    "prompt": "We need to decide between implementing a microservices architecture or a monolithic approach for our new e-commerce platform. What factors should guide this decision?"
}'

echo "🧭 Testing Pilot Role"
echo "===================="
test_endpoint "Pilot Architecture" "/pilot" '{
    "prompt": "Design a user authentication system that supports OAuth2, multi-factor authentication, and session management. Provide a high-level architecture and identify key components."
}'

echo "⚔️ Testing Gunner Role"
echo "====================="
test_endpoint "Gunner Implementation" "/gunner" '{
    "prompt": "Implement a Python function that validates JWT tokens, checks expiration, and extracts user claims. Include comprehensive error handling and unit tests."
}'

# Performance test
echo "🚀 Performance Test"
echo "==================="
echo "Running concurrent requests..."

start_time=$(date +%s)
for i in {1..3}; do
    curl -s -X POST "$BASE_URL/pilot" \
        -H "Content-Type: application/json" \
        -d '{"prompt": "Quick test request '$i'"}' \
        --max-time 30 > /dev/null &
done

wait
end_time=$(date +%s)
duration=$((end_time - start_time))

echo -e "${GREEN}✅ Concurrent requests completed in ${duration}s${NC}"
echo ""

# Model test
echo "🤖 Model Information"
echo "==================="
if model_response=$(curl -s -X POST "$BASE_URL/commander" \
    -H "Content-Type: application/json" \
    -d '{"prompt": "What model are you using and what are your capabilities?"}' \
    --max-time 30); then
    
    model=$(echo "$model_response" | jq -r '.model')
    echo "Active model: $model"
    echo "Response: $(echo "$model_response" | jq -r '.response' | head -c 200)..."
fi
echo ""

echo "🎉 Test Suite Complete!"
echo ""
echo "📊 Summary:"
echo "- Health check: ✅"
echo "- Commander endpoint: Tested"
echo "- Pilot endpoint: Tested" 
echo "- Gunner endpoint: Tested"
echo "- Performance: Tested"
echo ""
echo "🔗 Access your Cylon Raider at: $BASE_URL"
echo "📚 API documentation: $BASE_URL/docs"
