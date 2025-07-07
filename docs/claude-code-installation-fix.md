# Claude Code Installation Fix - Architectural Decision

**Date:** July 5, 2025  
**Issue:** Incorrect Claude Code installation method in setup script  
**Status:** ✅ FIXED

## Problem Identified

The setup script was using a non-existent installation URL:
```bash
# ❌ This was wrong:
curl -fsSL https://claude.ai/claude-code/install.sh | sh
```

## Root Cause

Made an incorrect assumption about Claude Code installation method without checking the official documentation first.

## Correct Installation Method

Based on official Anthropic documentation at https://docs.anthropic.com/en/docs/claude-code/setup:

### Prerequisites
- **Node.js 18+** (required for npm installation)
- **Supported OS**: macOS 10.15+, Ubuntu 20.04+/Debian 10+, Windows via WSL

### Installation Steps
```bash
# 1. Install Node.js (if not present)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# 2. Install Claude Code via npm (no sudo!)
npm install -g @anthropic-ai/claude-code

# 3. Verify installation
claude --version
```

### Command Usage
- **CLI Command**: `claude` (not `claude-code`)
- **Basic Usage**: `claude "your prompt here"`
- **No --work-dir flag needed** - Claude automatically works in current directory

## Files Updated

### 1. **Setup Script** (`runner-setup/setup-local-runner.sh`)
```bash
# Added Node.js installation check
# Correct npm installation: npm install -g @anthropic-ai/claude-code
# Fixed command references: claude instead of claude-code
```

### 2. **GitHub Workflow** (`.github/workflows/cylon-development.yml`)
```yaml
# Fixed command usage:
claude "You are the Pilot..." # instead of claude-code --prompt "..." --work-dir
```

### 3. **Testing Scripts**
- `scripts/test-claude-integration.sh` - Updated command references
- `scripts/check-claude-integration.sh` - Fixed CLI detection
- Workspace test scripts - Corrected command usage

### 4. **Documentation** (`docs/github-secrets-setup.md`)
- Added Node.js installation requirements
- Corrected Claude Code installation instructions
- Added Windows/WSL notes

## Verification Commands

After running the corrected setup:

```bash
# Check Node.js
node --version    # Should show v18+

# Check Claude Code installation
claude --version  # Should show Claude Code version

# Test functionality (with API key)
export ANTHROPIC_API_KEY="your-key-here"
claude "Create a simple hello world Python script"
```

## Authentication Note

Claude Code requires authentication on first use:
- **Anthropic Console**: Default option (requires billing)
- **Claude Pro/Max**: Unified subscription option
- **Enterprise**: Bedrock/Vertex AI integration

## Benefits of Correct Installation

✅ **Proper dependency management** - Node.js ecosystem integration  
✅ **Standard npm workflow** - Familiar to developers  
✅ **Automatic updates** - `npm update -g @anthropic-ai/claude-code`  
✅ **Cross-platform consistency** - Same installation method everywhere  
✅ **Official support** - Following Anthropic's documented process  

## Impact

- ✅ Setup script now works correctly
- ✅ Claude Code integrates properly with file system
- ✅ Workflows execute without installation errors
- ✅ Testing and verification scripts function properly
- ✅ Documentation matches official requirements

This fix ensures the Cylon Raider system can properly leverage Claude Code's intelligent filesystem reasoning capabilities.
