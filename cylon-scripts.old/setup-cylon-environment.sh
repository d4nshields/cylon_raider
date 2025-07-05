#!/bin/bash
# setup-cylon-environment.sh
# Sets up the Cylon Raider development environment on the VM

set -e

echo "🤖 Setting up Cylon Raider Environment"
echo "======================================"

# Create project structure
mkdir -p ~/cylon-raider/{commander,pilot,gunner,shared}
mkdir -p ~/cylon-raider/logs
mkdir -p ~/cylon-raider/config

# Create configuration files
cat > ~/cylon-raider/config/cylon.conf << EOF
# Cylon Raider Configuration
OLLAMA_URL=http://localhost:11434
API_PORT=8080
LOG_LEVEL=INFO
MODEL_DEFAULT=llama3.2:8b-instruct-q4_K_M
WORKSPACE_ROOT=/home/ubuntu/cylon-raider
EOF

# Create API service
cat > ~/cylon-raider/cylon-api.py << 'EOF'
#!/usr/bin/env python3
"""
Cylon Raider API Service
Provides HTTP endpoints for Commander, Pilot, and Gunner interactions
"""

import os
import json
import time
import requests
import logging
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Optional, Dict, Any
import uvicorn

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(title="Cylon Raider API", version="1.0.0")

# Configuration
OLLAMA_URL = os.getenv("OLLAMA_URL", "http://localhost:11434")
MODEL_DEFAULT = os.getenv("MODEL_DEFAULT", "llama3.2:8b-instruct-q4_K_M")

class CylonRequest(BaseModel):
    prompt: str
    model: Optional[str] = MODEL_DEFAULT
    role: Optional[str] = "assistant"
    context: Optional[Dict[str, Any]] = None

class CylonResponse(BaseModel):
    response: str
    model: str
    role: str
    timestamp: float
    execution_time: float

def call_ollama(prompt: str, model: str, system_prompt: str = "") -> str:
    """Call Ollama API with proper error handling"""
    try:
        full_prompt = f"{system_prompt}\n\n{prompt}" if system_prompt else prompt
        
        response = requests.post(f"{OLLAMA_URL}/api/generate", 
            json={
                "model": model,
                "prompt": full_prompt,
                "stream": False
            },
            timeout=120
        )
        
        if response.status_code == 200:
            return response.json()["response"]
        else:
            raise HTTPException(status_code=response.status_code, 
                              detail=f"Ollama API error: {response.text}")
    except requests.exceptions.RequestException as e:
        raise HTTPException(status_code=503, detail=f"Ollama service unavailable: {e}")

@app.get("/")
async def root():
    return {"message": "Cylon Raider API", "status": "operational"}

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    try:
        # Test Ollama connection
        response = requests.get(f"{OLLAMA_URL}/api/tags", timeout=5)
        ollama_status = "healthy" if response.status_code == 200 else "unhealthy"
    except:
        ollama_status = "unreachable"
    
    return {
        "api": "healthy",
        "ollama": ollama_status,
        "timestamp": time.time()
    }

@app.post("/commander", response_model=CylonResponse)
async def commander_endpoint(request: CylonRequest):
    """Commander role endpoint - strategic oversight and decision making"""
    system_prompt = """You are the Centurion Commander in a Cylon Raider Configuration development team. Your role is strategic oversight, quality assurance, and final decision-making authority. Provide clear, actionable guidance focusing on project goals, quality standards, and long-term maintainability."""
    
    start_time = time.time()
    response_text = call_ollama(request.prompt, request.model, system_prompt)
    execution_time = time.time() - start_time
    
    logger.info(f"Commander request processed in {execution_time:.2f}s")
    
    return CylonResponse(
        response=response_text,
        model=request.model,
        role="commander",
        timestamp=time.time(),
        execution_time=execution_time
    )

@app.post("/pilot", response_model=CylonResponse)
async def pilot_endpoint(request: CylonRequest):
    """Pilot role endpoint - architecture and planning"""
    system_prompt = """You are the Pilot in a Cylon Raider Configuration development team. Your role is navigation, dependency management, and solution architecture. Focus on analyzing requirements, designing optimal solutions, and creating detailed specifications for implementation."""
    
    start_time = time.time()
    response_text = call_ollama(request.prompt, request.model, system_prompt)
    execution_time = time.time() - start_time
    
    logger.info(f"Pilot request processed in {execution_time:.2f}s")
    
    return CylonResponse(
        response=response_text,
        model=request.model,
        role="pilot",
        timestamp=time.time(),
        execution_time=execution_time
    )

@app.post("/gunner", response_model=CylonResponse)
async def gunner_endpoint(request: CylonRequest):
    """Gunner role endpoint - precise implementation and testing"""
    system_prompt = """You are the Gunner in a Cylon Raider Configuration development team. Your role is precise implementation, testing, and tactical execution. Focus on writing clean, maintainable code with comprehensive tests according to provided specifications."""
    
    start_time = time.time()
    response_text = call_ollama(request.prompt, request.model, system_prompt)
    execution_time = time.time() - start_time
    
    logger.info(f"Gunner request processed in {execution_time:.2f}s")
    
    return CylonResponse(
        response=response_text,
        model=request.model,
        role="gunner",
        timestamp=time.time(),
        execution_time=execution_time
    )

if __name__ == "__main__":
    port = int(os.getenv("API_PORT", 8080))
    uvicorn.run(app, host="0.0.0.0", port=port)
EOF

chmod +x ~/cylon-raider/cylon-api.py

# Create systemd service for the API
sudo tee /etc/systemd/system/cylon-api.service > /dev/null << EOF
[Unit]
Description=Cylon Raider API Service
After=network.target ollama.service
Requires=ollama.service

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/cylon-raider
Environment=PATH=/usr/bin:/usr/local/bin
Environment=OLLAMA_URL=http://localhost:11434
Environment=API_PORT=8080
ExecStart=/usr/bin/python3 /home/ubuntu/cylon-raider/cylon-api.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

echo "✅ Cylon environment setup complete!"
echo "Configuration saved to ~/cylon-raider/config/"
echo "API service created at ~/cylon-raider/cylon-api.py"
echo "Systemd service configured for automatic startup"
