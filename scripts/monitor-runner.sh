#!/bin/bash
# monitor-runner.sh
# Monitor GitHub Actions runner and system health

echo "🏃 GitHub Actions Runner Monitor"
echo "==============================="
echo ""

# Check runner status
if pgrep -f "actions-runner" >/dev/null; then
    runner_pid=$(pgrep -f "actions-runner")
    echo "✅ Runner Status: Active (PID: $runner_pid)"
    
    # Find runner directory
    runner_dir=$(ps -p $runner_pid -o cmd --no-headers | grep -o '/[^ ]*/actions-runner[^ ]*' | head -1)
    if [ -n "$runner_dir" ]; then
        runner_dir=$(dirname "$runner_dir")
        echo "📁 Runner Directory: $runner_dir"
        
        # Show recent logs
        if [ -f "$runner_dir/_diag/Runner_$(date +%Y%m%d)-*.log" ]; then
            echo ""
            echo "📝 Recent Runner Activity:"
            tail -5 "$runner_dir"/_diag/Runner_$(date +%Y%m%d)-*.log
        fi
    fi
else
    echo "❌ Runner Status: Inactive"
    echo ""
    echo "To start the runner:"
    echo "1. Navigate to your runner directory"
    echo "2. Run: ./run.sh"
    echo "3. Or use screen: screen -S runner ./run.sh"
fi
echo ""

# System resources
echo "💻 System Resources:"
echo "CPU Usage: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | sed 's/%us,//')"
echo "Memory: $(free -h | awk '/^Mem:/{printf "Used: %s / Total: %s (%.1f%%)\n", $3, $2, $3/$2*100}')"
echo "Disk: $(df -h / | awk 'NR==2{printf "Used: %s / Total: %s (%s)\n", $3, $2, $5}')"
echo "Load Average: $(uptime | awk -F'load average:' '{print $2}')"
echo ""

# Ollama status
echo "🦙 Ollama Status:"
if systemctl is-active ollama >/dev/null 2>&1; then
    echo "Service: Running ✅"
    if curl -s http://localhost:11434/api/tags >/dev/null; then
        echo "API: Responding ✅"
        model_count=$(ollama list | tail -n +2 | wc -l)
        echo "Models: $model_count installed"
        
        # Show recent Ollama activity
        echo ""
        echo "🔍 Recent Ollama Activity:"
        journalctl -u ollama --since "10 minutes ago" --no-pager -n 3 2>/dev/null || echo "No recent activity"
    else
        echo "API: Not responding ❌"
    fi
else
    echo "Service: Stopped ❌"
    echo "To start: sudo systemctl start ollama"
fi
echo ""

# Network info
echo "🌐 Network Information:"
if command -v curl >/dev/null; then
    external_ip=$(curl -s ifconfig.me 2>/dev/null || echo "unknown")
    echo "External IP: $external_ip"
fi
internal_ip=$(hostname -I | awk '{print $1}')
echo "Internal IP: $internal_ip"
echo "Hostname: $(hostname)"
echo ""

# GitHub CLI check
echo "🔧 GitHub CLI:"
if command -v gh >/dev/null; then
    gh_auth=$(gh auth status 2>&1 | grep -o "Logged in.*as.*" || echo "Not authenticated")
    echo "Status: $gh_auth"
else
    echo "Status: Not installed"
    echo "Install: https://cli.github.com/"
fi
echo ""

# Storage space for models
echo "💾 Model Storage:"
if [ -d ~/.ollama ]; then
    ollama_size=$(du -sh ~/.ollama 2>/dev/null | cut -f1)
    echo "Ollama directory: $ollama_size"
fi
if [ -d /opt/ollama ]; then
    opt_size=$(du -sh /opt/ollama 2>/dev/null | cut -f1)
    echo "System Ollama: $opt_size"
fi

# Quick recommendations
echo ""
echo "💡 Quick Actions:"
if ! pgrep -f "actions-runner" >/dev/null; then
    echo "- Start runner: cd [runner-dir] && ./run.sh"
fi

if ! systemctl is-active ollama >/dev/null 2>&1; then
    echo "- Start Ollama: sudo systemctl start ollama"
fi

if ! curl -s http://localhost:11434/api/tags >/dev/null; then
    echo "- Check Ollama: curl http://localhost:11434/api/tags"
fi

echo "- Test roles: ./scripts/test-cylon-roles.sh"
echo "- View full logs: journalctl -u ollama -f"
