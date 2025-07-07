# Cylon Raider - Complete Setup and Testing Guide

## 📋 Current Project Status

✅ **Architecture**: Claude Code integration (pure, no Ollama fallback)  
✅ **Installation**: Corrected npm-based Claude Code installation  
✅ **Workflows**: GitHub Actions with self-hosted runners  
✅ **Documentation**: Updated for Claude Code focus  

## 🚀 Complete Setup Checklist

### Step 1: Set Up Local Runner
```bash
cd /home/daniel/work/cylon_raider
./runner-setup/setup-local-runner.sh
```

**What this does:**
- Installs Docker (for GitHub Actions runner)
- Installs Node.js 18+ (required for Claude Code)
- Installs Claude Code CLI: `npm install -g @anthropic-ai/claude-code`
- Creates ~/cylon-workspace/ with helper scripts
- Verifies all installations

### Step 2: Configure GitHub Secrets
1. **Go to**: Your GitHub repo → Settings → Secrets and variables → Actions
2. **Create secret**: Name: `ANTHROPIC_API_KEY`, Value: your Anthropic API key
3. **Get API key**: https://console.anthropic.com/ (requires billing setup)
4. **Full guide**: `docs/github-secrets-setup.md`

### Step 3: Configure GitHub Runner
```bash
# Run the helper script for GitHub runner setup instructions
~/cylon-workspace/configure-runner.sh
```

**Manual steps needed:**
1. Go to: Your GitHub repo → Settings → Actions → Runners
2. Click "New self-hosted runner"
3. Follow the installation commands provided
4. Runner should appear as "Idle" when ready

### Step 4: Test Local Setup
```bash
# Test Claude Code CLI installation
./scripts/test-claude-integration.sh

# Alternative check
./scripts/check-claude-integration.sh
```

## 🧪 Correct Testing Commands

### Basic Workflow Test
```bash
# Correct command with required parameters:
gh workflow run cylon-development.yml \
  -f feature_description="Create a simple hello world function" \
  -f priority="medium" \
  -f commander_approval="approved"
```

### More Test Examples
```bash
# Test with different priorities
gh workflow run cylon-development.yml \
  -f feature_description="Build a calculator API" \
  -f priority="high" \
  -f commander_approval="approved"

# Test approval gate (should fail intentionally)
gh workflow run cylon-development.yml \
  -f feature_description="Some feature" \
  -f priority="low" \
  -f commander_approval="needs-analysis"
```

### Monitor Workflow Execution
```bash
# Watch workflows in real-time
gh workflow list
gh run list --workflow=cylon-development.yml

# Check specific run status
gh run view [RUN_ID]
```

## 📊 What Success Looks Like

### 1. **Successful Workflow Execution**
- ✅ Commander Gate: Processes approval
- ✅ Pilot Architecture: Claude creates docs/architecture/pilot-design.md
- ✅ Gunner Implementation: Claude creates code files and tests
- ✅ Pull Request: Created automatically for review

### 2. **Generated Artifacts**
```
your-repo/
├── docs/architecture/pilot-design.md     # AI-generated architecture
├── src/                                  # AI-generated implementation
├── tests/                               # AI-generated tests
└── Pull Requests ready for review       # experiment→feature branch
```

### 3. **Git Branch Structure**
```
main                                     # Your production code
├── feature/create-a-simple-hello-world-function  # Pilot workspace
│   └── experiment/create-a-simple...    # Gunner workspace (PR source)
```

## 🔍 Troubleshooting

### Common Issues & Solutions

**❌ "Required input not provided"**
```bash
# WRONG:
gh workflow run cylon-development.yml

# CORRECT:
gh workflow run cylon-development.yml \
  -f feature_description="your feature" \
  -f commander_approval="approved"
```

**❌ "Claude command not found"**
```bash
# Check installation:
which claude
npm list -g @anthropic-ai/claude-code

# Reinstall if needed:
npm install -g @anthropic-ai/claude-code
```

**❌ "No self-hosted runners available"**
- Ensure runner is configured and showing "Idle" in GitHub
- Check runner logs: `sudo journalctl -u actions.runner.*`

**❌ "ANTHROPIC_API_KEY not found"**
- Verify secret is set in GitHub repo settings
- Check API key has billing enabled at console.anthropic.com

## 🎯 Recommended First Test

**Start Simple:**
```bash
gh workflow run cylon-development.yml \
  -f feature_description="Add a simple add(a, b) function that returns a + b" \
  -f priority="low" \
  -f commander_approval="approved"
```

**Expected Result:**
1. Workflow runs for ~2-5 minutes
2. Creates branch: `feature/add-a-simple-add-a-b-function-that-returns-a-b`
3. Claude Pilot creates architecture documentation
4. Claude Gunner implements the function with tests
5. Pull request appears for your review
6. You approve experiment→feature→main as Commander

## 📈 Scaling Up

Once basic test works:

```bash
# More complex features
gh workflow run cylon-development.yml \
  -f feature_description="Build a REST API for user authentication with JWT tokens" \
  -f priority="high" \
  -f commander_approval="approved"

# Large architecture projects
gh workflow run cylon-development.yml \
  -f feature_description="Design and implement a microservices architecture for order processing" \
  -f priority="critical" \
  -f commander_approval="approved"
```

## 🎖️ Your Role as Commander

1. **Strategic Approval**: Decide which features to build
2. **Quality Gates**: Review all PRs before merging
3. **Architecture Oversight**: Ensure Claude's designs align with your vision
4. **Production Control**: Final approval for main branch merges

**You command the AI development team - they execute your strategic decisions!** 🚀
