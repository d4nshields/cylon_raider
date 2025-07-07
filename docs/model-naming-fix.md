# Model Naming Fix - Architectural Decision

**Date:** July 5, 2025  
**Issue:** Ollama model naming error causing setup failures  
**Status:** ✅ RESOLVED

## Problem Description

The Cylon Raider setup script was attempting to download `llama3.2:8b`, which does not exist in the Ollama library. This caused "manifest not found" errors during setup.

## Root Cause Analysis

- **Issue:** Meta's Llama 3.2 series only includes 1B and 3B parameter models
- **Available Llama 3.2 models:** `llama3.2:1b`, `llama3.2:3b`
- **Script error:** Trying to download non-existent `llama3.2:8b`

## Solution Implemented

Updated `runner-setup/setup-local-runner.sh` to use correct model names:

### Before (❌ Broken):
```bash
download_if_missing "llama3.2:8b"    # Does not exist
```

### After (✅ Fixed):
```bash
download_if_missing "llama3.1:8b"    # Correct 8B model
```

## Complete Model Strategy

**High RAM Systems (16GB+):**
- `llama3.1:8b` - Strategic/Commander tasks (4.9GB)
- `qwen2.5:7b` - Architecture/Pilot tasks
- `codellama:7b` - Implementation/Gunner tasks

**Medium RAM Systems (8GB+):**
- `qwen2.5:7b` - Architecture tasks
- `codellama:7b` - Implementation tasks

**Low RAM Systems (<8GB):**
- `llama3.2:3b` - General purpose tasks
- `qwen2.5:3b` - Lightweight alternative

## Files Modified

1. **`runner-setup/setup-local-runner.sh`**
   - Changed `llama3.2:8b` → `llama3.1:8b`

2. **`scripts/check-available-models.sh`**
   - Updated model testing list
   - Added correct size variants
   - Improved help text with proper model names

## Verification

After this fix, users can successfully:
```bash
# Test the fix
./scripts/check-available-models.sh

# Run corrected setup
./runner-setup/setup-local-runner.sh
```

## Canonical Ollama Model Names (2025)

For reference, these are the correct model names for Cylon Raider:

| Model Family | Sizes Available | Cylon Role |
|--------------|----------------|------------|
| `llama3.1` | 8b, 70b, 405b | Commander (strategic) |
| `llama3.2` | 1b, 3b | Lightweight general use |
| `qwen2.5` | 0.5b, 1.5b, 3b, 7b, 14b, 32b, 72b | Pilot (architecture) |
| `codellama` | 7b, 13b, 34b, 70b | Gunner (implementation) |

## Impact

- ✅ Setup script now completes successfully
- ✅ No more "manifest not found" errors
- ✅ Proper model allocation based on system RAM
- ✅ Maintains original Cylon Raider functionality

## Future Considerations

- Monitor Ollama library for new model releases
- Consider adding model verification step in CI/CD
- Document model update procedure for future releases
