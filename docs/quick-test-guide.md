# Quick Test Guide - Smart Claude Implementation

## 🧪 Testing the Hybrid Implementation

### **Issue:** Your test hung on Claude Code CLI interactive prompt
### **Solution:** Use `--api` flag to force API mode for testing

## Test Commands

### **1. Test API Mode (Recommended for CI/CD testing)**
```bash
# This bypasses Claude Code CLI and uses direct API
export ANTHROPIC_API_KEY="your-key-here"
./scripts/smart-claude.sh --api "Create a simple Python hello world script"
```

**Expected Result:**
- ✅ Uses Anthropic API directly
- ✅ Creates `hello_world.py` file
- ✅ No interactive prompts
- ✅ Shows API response and file creation

### **2. Test Claude Code CLI Mode (Interactive)**
```bash
# This uses Claude Code CLI if you want to test local mode
./scripts/smart-claude.sh "Create a simple Python hello world script"
```

**Expected Result:**
- 💻 Uses Claude Code CLI
- ❓ May prompt for file creation confirmation
- 🔐 Requires Claude Code authentication

### **3. Test GitHub Actions Simulation**
```bash
# Simulate GitHub Actions environment
export GITHUB_ACTIONS="true"
export ANTHROPIC_API_KEY="your-key-here"
./scripts/smart-claude.sh "Create a simple Python hello world script"
```

## Environment Detection Logic

| Environment | Detection | Mode Used |
|-------------|-----------|-----------|
| **GitHub Actions** | `$GITHUB_ACTIONS` set | 🤖 Anthropic API |
| **Local with `--api`** | `--api` flag | 🤖 Anthropic API |
| **Local development** | Default | 💻 Claude Code CLI |

## Workflow Testing

### **Cancel Stuck Workflow**
```bash
gh run cancel 16104743237
```

### **Run New Workflow**
```bash
gh workflow run cylon-development.yml \
  -f feature_description="Create a simple add function" \
  -f commander_approval="approved"
```

### **Monitor New Workflow**
```bash
gh run list --workflow=cylon-development.yml
gh run view [NEW_RUN_ID]
```

## Expected Workflow Behavior

1. **Pilot Stage**: Uses API mode → Creates `docs/architecture/pilot-design.md`
2. **Gunner Stage**: Uses API mode → Creates implementation files and tests
3. **No hanging**: Completes in ~2-5 minutes
4. **Pull Request**: Generated for review

## Troubleshooting

### **❌ "jq: command not found"**
```bash
# Install jq
sudo apt-get install jq  # Linux
brew install jq          # macOS
```

### **❌ API call fails**
- Check API key: `echo $ANTHROPIC_API_KEY`
- Verify billing enabled at console.anthropic.com
- Test with curl directly

### **❌ No files created**
- Check API response in output
- Verify file processor is working
- Look for permission errors

## Success Indicators

✅ **API Mode Works**: Files created without prompts  
✅ **Response Processing**: Files extracted from Claude response  
✅ **Workflow Completes**: No hanging in GitHub Actions  
✅ **Files Generated**: Actual code files in repository  

## Next Steps After Testing

1. ✅ **Verify API mode works** with `--api` flag
2. ✅ **Run new workflow** to test full integration
3. ✅ **Check generated files** for quality
4. ✅ **Review and merge** pull requests as Commander

**Ready to test with the `--api` flag?** This will bypass the interactive Claude Code CLI and use the API directly! 🚀
