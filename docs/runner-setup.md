# Self-Hosted Runner Setup Guide

This guide walks you through setting up a GitHub Actions self-hosted runner for the Cylon Raider development methodology.

## 🎯 Overview

Self-hosted runners give you:
- **Complete control** over your AI compute resources
- **No capacity limits** or provider outages
- **Model persistence** (no re-downloading)
- **Hardware flexibility** from 8GB laptop to 128GB workstation
- **Cost control** - use free cloud, paid cloud, or local hardware

## 🏗️ Architecture

```
GitHub Repository
       ↓ (workflow trigger)
Self-Hosted Runner
       ↓ (API calls)
Local Ollama Instance
       ↓ (model inference)
AI Models (Commander/Pilot/Gunner)
```

## 📋 Prerequisites

### Minimum Requirements
- **8GB RAM** (for 3B-7B models)
- **20GB free disk space** (for models and cache)
- **2+ CPU cores**
- **Stable internet connection**

### Recommended Requirements
- **16GB+ RAM** (for 7B-8B models)
- **50GB+ free disk space**
- **4+ CPU cores**
- **ARM64 or modern x86_64 processor**

## 🚀 Quick Setup Options

### Option 1: Local Machine Setup

Perfect for development and testing:

```bash
git clone https://github.com/yourusername/cylon_raider.git
cd cylon_raider
./runner-setup/setup-local-runner.sh
```

**What it does:**
- Installs Docker and Ollama
- Downloads AI models based on your RAM
- Creates workspace directory
- Provides GitHub runner configuration guide

**Best for:** Development, learning, occasional use

### Option 2: Cloud VM Setup

Ideal for dedicated development or team use:

```bash
# On any cloud VM (AWS, GCP, Azure, DigitalOcean, etc.)
git clone https://github.com/yourusername/cylon_raider.git
cd cylon_raider
./runner-setup/setup-cloud-runner.sh
```

**What it does:**
- Auto-detects cloud provider
- Optimizes system for AI workloads
- Configures persistent services
- Sets up monitoring and maintenance

**Best for:** Production use, team collaboration, 24/7 availability

### Option 3: Oracle Cloud (Free Tier)

Get powerful ARM hardware at no cost:

```bash
# On Oracle Cloud ARM instance
git clone https://github.com/yourusername/cylon_raider.git
cd cylon_raider
./runner-setup/setup-oracle-runner.sh
```

**What it does:**
- Optimizes for ARM Ampere A1 processors
- Configures for Oracle Cloud's Always Free tier
- Maximizes the 4 CPU / 24GB RAM allocation
- Sets up monitoring for resource usage

**Best for:** Free powerful compute, ARM development, cost-conscious users

## 🔧 Manual Setup Process

If you prefer to set up manually or need custom configuration:

### 1. Install Dependencies

**Docker:**
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
```

**Ollama:**
```bash
curl -fsSL https://ollama.com/install.sh | sh
```

### 2. Download AI Models

Choose models based on your available RAM:

**8GB RAM (Basic):**
```bash
ollama pull llama3.2:3b-instruct  # Commander
ollama pull qwen2.5:3b-instruct   # Pilot/Gunner
```

**16GB RAM (Standard):**
```bash
ollama pull llama3.2:8b-instruct  # Commander
ollama pull qwen2.5:7b-instruct   # Pilot
ollama pull codellama:7b-instruct # Gunner
```

**24GB+ RAM (Maximum):**
```bash
ollama pull llama3.2:8b-instruct  # Commander
ollama pull qwen2.5:7b-instruct   # Pilot
ollama pull codellama:7b-instruct # Gunner
ollama pull llama3.1:13b-instruct # Advanced tasks
```

### 3. Configure GitHub Runner

1. **Go to your GitHub repository**
2. **Settings → Actions → Runners**
3. **Click "New self-hosted runner"**
4. **Choose your OS (Linux/macOS/Windows)**
5. **Follow the download and configuration instructions**

**Recommended configuration:**
- **Name:** `cylon-[hostname]`
- **Labels:** `cylon,self-hosted,[architecture],ollama`
- **Work folder:** `~/cylon-workspace/runners`

### 4. Start the Runner

```bash
# In the runner directory
./run.sh
```

**For persistent operation:**
```bash
# Use screen or tmux to keep runner active
screen -S github-runner
./run.sh
# Press Ctrl+A, then D to detach
```

## 🎮 Testing Your Setup

### Basic Test
```bash
# Test Ollama installation
ollama run llama3.2:3b-instruct "Say 'Cylon systems operational'"
```

### Workflow Test
```bash
# Trigger a test workflow
gh workflow run cylon-development.yml \
  -f feature_description="test setup" \
  -f priority="low"
```

### System Monitoring
```bash
# Monitor system resources
htop

# Check Ollama status
systemctl status ollama

# Monitor runner logs
tail -f ~/actions-runner/_diag/Runner_*.log
```

## 🛠️ Configuration Options

### Ollama Configuration

Edit `/etc/systemd/system/ollama.service.d/override.conf`:

```ini
[Service]
Environment="OLLAMA_HOST=0.0.0.0:11434"
Environment="OLLAMA_MODELS=/opt/ollama/models"
Environment="OLLAMA_MAX_LOADED_MODELS=3"
Environment="OLLAMA_NUM_PARALLEL=4"
Environment="OLLAMA_MAX_QUEUE=512"
```

### Runner Configuration

Customize your runner's `runsettings.json`:

```json
{
  "workingDirectory": "~/cylon-workspace/runners",
  "labels": ["cylon", "self-hosted", "ollama"],
  "name": "cylon-runner-1"
}
```

## 🔍 Troubleshooting

### Common Issues

**Ollama not responding:**
```bash
systemctl restart ollama
curl http://localhost:11434/api/tags
```

**Runner disconnected:**
```bash
# Check runner logs
cat ~/actions-runner/_diag/Runner_*.log

# Restart runner
./config.sh remove
./config.sh --url https://github.com/user/repo --token [TOKEN]
```

**Out of memory errors:**
```bash
# Check memory usage
free -h

# Add swap space
sudo fallocate -l 8G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

**Model download failures:**
```bash
# Clear Ollama cache
rm -rf ~/.ollama/models/*

# Re-download models
ollama pull llama3.2:3b-instruct
```

### Performance Optimization

**For ARM processors:**
```bash
# Enable ARM optimizations
export OLLAMA_NUM_PARALLEL=$(nproc)
export OLLAMA_FLASH_ATTENTION=1
```

**For limited RAM:**
```bash
# Use smaller models
ollama pull llama3.2:1b-instruct
ollama pull qwen2.5:1.5b-instruct
```

**For better response times:**
```bash
# Keep models loaded
export OLLAMA_KEEP_ALIVE=30m
```

## 📊 Model Recommendations

| RAM | Commander | Pilot | Gunner | Notes |
|-----|-----------|--------|---------|-------|
| 8GB | llama3.2:3b | qwen2.5:3b | qwen2.5:3b | Basic setup |
| 16GB | llama3.2:8b | qwen2.5:7b | codellama:7b | Recommended |
| 24GB+ | llama3.2:8b | qwen2.5:7b | codellama:13b | High performance |
| 32GB+ | llama3.1:13b | qwen2.5:14b | codellama:13b | Maximum capability |

## 🌐 Network Configuration

### Firewall Settings
```bash
# Allow Ollama API access (optional)
sudo ufw allow 11434/tcp

# For cloud instances, configure security groups
# Allow inbound TCP 11434 from your IP
```

### Remote Access
```bash
# SSH tunnel for secure access
ssh -L 11434:localhost:11434 user@your-server

# Then access via http://localhost:11434
```

## 🔒 Security Considerations

### Best Practices
- **Use SSH keys** for server access
- **Limit network exposure** of Ollama API
- **Regular updates** of system packages
- **Monitor resource usage** to prevent abuse
- **Backup important data** regularly

### Production Hardening
```bash
# Disable password authentication
sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Enable automatic security updates
sudo dpkg-reconfigure -plow unattended-upgrades

# Configure fail2ban
sudo apt install fail2ban
```

## 💰 Cost Optimization

### Free Options
- **Oracle Cloud Always Free:** 4 ARM cores, 24GB RAM, 200GB storage
- **Google Cloud Free Tier:** $300 credit for new accounts
- **AWS Free Tier:** t2.micro instance for 12 months
- **Local hardware:** Use existing computers

### Paid Optimization
- **Spot instances** for development (50-70% cost savings)
- **Reserved instances** for production workloads
- **ARM instances** generally offer better price/performance
- **Monitor and auto-shutdown** during idle periods

## 📈 Scaling

### Single Developer
- **Local machine** for development
- **Small cloud instance** for testing
- **Shared runner** for CI/CD

### Team Setup
- **Dedicated cloud instances** per developer
- **Shared powerful instance** with multiple runners
- **Load balancing** across multiple regions

### Enterprise
- **Runner pools** with auto-scaling
- **Dedicated hardware** for sensitive workloads
- **Multi-region deployment** for reliability

## 🎯 Next Steps

After setup:

1. **Test basic workflows** with simple features
2. **Experiment with different models** for each role
3. **Optimize for your hardware** configuration
4. **Set up monitoring** and alerting
5. **Backup your configuration** and models

## 📚 Additional Resources

- [GitHub Self-Hosted Runners Documentation](https://docs.github.com/en/actions/hosting-your-own-runners)
- [Ollama Documentation](https://ollama.com/docs)
- [System Prompts Reference](../system-prompts/)
- [Workflow Examples](../examples/)
- [Troubleshooting Guide](./troubleshooting.md)
