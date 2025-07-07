# GitHub Secrets Configuration for Cylon Raider

**Required for:** Claude Code integration in Pilot and Gunner AI roles

## 🔑 Setting Up ANTHROPIC_API_KEY

### Step 1: Get Your Anthropic API Key

1. **Sign up/Login** to [Anthropic Console](https://console.anthropic.com/)
2. **Navigate to API Keys** in the dashboard
3. **Create a new API key** 
4. **Copy the key** (starts with `sk-ant-...`)
5. **Important:** Store this key securely - you won't see it again!

### Step 2: Add Secret to GitHub Repository

1. **Go to your GitHub repository**
2. **Click:** Settings → Secrets and variables → Actions
3. **Click:** "New repository secret"
4. **Name:** `ANTHROPIC_API_KEY`
5. **Value:** Your Anthropic API key (paste the full key)
6. **Click:** "Add secret"

### Step 3: Verify Setup

The secret should now appear in your repository secrets list as:
```
ANTHROPIC_API_KEY ••••••••••••••••
```

## 🔒 Security Best Practices

### ✅ DO:
- ✅ Use GitHub repository secrets (never commit keys to code)
- ✅ Limit API key permissions if available
- ✅ Monitor API usage in Anthropic Console
- ✅ Rotate keys periodically
- ✅ Use organization secrets for multiple repos (if applicable)

### ❌ DON'T:
- ❌ Commit API keys to version control
- ❌ Share keys in chat/email
- ❌ Use the same key across multiple unrelated projects
- ❌ Leave unused keys active

## 🔧 Installation Requirements

### Node.js Requirement
Claude Code is installed via npm and requires Node.js 18+:

**Linux:**
```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```

**macOS:**
```bash
# Install from https://nodejs.org/en/download
# OR use homebrew:
brew install node
```

**Windows:**
- Install Node.js from https://nodejs.org/en/download
- Use WSL for Claude Code (Windows Subsystem for Linux)

### Claude Code Installation
After Node.js is installed:
```bash
npm install -g @anthropic-ai/claude-code
```

**Important:** Do NOT use `sudo npm install` as this can cause permission issues.

## 💰 Cost Management

### API Usage Monitoring
- **Monitor usage** in [Anthropic Console](https://console.anthropic.com/settings/usage)
- **Set spending limits** if available
- **Track per-workflow costs** in the usage dashboard

### Estimated Costs for Cylon Raider
Typical workflow costs (approximate):

| Component | Task | Estimated Tokens | Cost Range |
|-----------|------|------------------|------------|
| Pilot | Architecture design | 2,000-5,000 | $0.03-$0.08 |
| Gunner | Implementation | 3,000-8,000 | $0.05-$0.13 |
| **Total per workflow** | | 5,000-13,000 | **$0.08-$0.21** |

*Costs based on Claude Sonnet pricing as of 2025. Check current pricing at console.anthropic.com*

## 🧪 Testing Your Setup

After adding the secret, test with a simple workflow:

```bash
# Run a small test feature
gh workflow run cylon-development.yml \
  -f feature_description="Add a simple hello function" \
  -f priority="low" \
  -f commander_approval="approved"
```

### Troubleshooting

**If you see authentication errors:**
1. ✅ Verify secret name is exactly `ANTHROPIC_API_KEY`
2. ✅ Check API key is valid in Anthropic Console
3. ✅ Ensure API key has sufficient credits
4. ✅ Check workflow logs for specific error messages

**Common error messages:**
- `Authentication failed` → Check API key validity
- `Rate limit exceeded` → Wait or upgrade plan
- `Insufficient credits` → Add billing method to Anthropic account

## 🔄 Fallback Strategy

If Claude Code is unavailable, the system will fall back to local Ollama models:

```bash
# The setup script installs both:
✅ Claude Code CLI (primary)
✅ Ollama + local models (fallback)
```

This ensures your Cylon Raider system works even if there are API issues.

## 📋 Next Steps

1. ✅ **Add the secret** following steps above
2. ✅ **Run setup script** to install Claude Code CLI
3. ✅ **Test the workflow** with a simple feature
4. ✅ **Monitor costs** in Anthropic Console
5. ✅ **Scale up** to more complex features

Your Cylon Raider team will now have intelligent filesystem access for both architecture design and implementation! 🚀
