# Cylon Raider Configuration

A development methodology inspired by the original 1970s Battlestar Galactica, where human oversight (Commander) coordinates AI specialists (Pilot & Gunner) through structured GitHub Actions workflows using self-hosted runners.

## 🎯 Core Concept

**Three-Role Development Pipeline:**
- **🎯 Commander (YOU - Human)**: Strategic oversight, quality gates, final decisions
- **🧭 Pilot (AI)**: Architecture, planning, dependency management  
- **⚔️ Gunner (AI)**: Implementation, testing, tactical execution

**Execution Environment:**
- **GitHub Actions** for workflow orchestration
- **Self-hosted runners** for reliable AI compute
- **Three-workspace git architecture** for quality control

## 🚀 Quick Start

### 1. Set Up Your Self-Hosted Runner

Choose your compute environment:

#### Option A: Local Machine (8GB+ RAM recommended)
```bash
# Clone and set up
git clone https://github.com/yourusername/cylon_raider.git
cd cylon_raider
./runner-setup/setup-local-runner.sh
```

#### Option B: Cloud VM (Any Provider)
```bash
# Deploy VM with 16GB+ RAM, then:
./runner-setup/setup-cloud-runner.sh
```

#### Option C: Oracle Cloud (Free Tier)
```bash
# If you want to use Oracle's free ARM instances:
./runner-setup/setup-oracle-runner.sh
```

### 2. Configure Your Development Workflow

```bash
# Initialize a new project with Cylon methodology
./workflows/init-cylon-project.sh my-new-project
```

### 3. Run Your First Cylon Mission

```bash
# As Commander, approve and trigger a development mission:
gh workflow run cylon-development.yml \
  -f feature_description="Build a user authentication system" \
  -f priority="high" \
  -f commander_approval="approved"
```

**Important:** You must set `commander_approval="approved"` to authorize AI development. This ensures human strategic oversight of every feature.

## 🏗️ Architecture

### Three-Workspace Git Structure

```
main (commander-workspace)     # Production-ready code
├── feature/user-auth (pilot-workspace)      # Architectural planning
│   └── experiment/auth-impl (gunner-workspace)  # Implementation & testing
├── feature/payment-system (pilot-workspace)
│   └── experiment/payment-impl (gunner-workspace)
```

### Quality Gates

1. **Human Strategic Approval**: Commander must pre-approve all features
2. **Experiment → Feature**: Pilot reviews Gunner implementations
3. **Feature → Main**: Commander final approval for production

### GitHub Actions Integration

```bash
# You (Commander) approve and trigger AI development:
gh workflow run cylon-development.yml \
  -f feature_description="Add user profiles" \
  -f commander_approval="approved"

# AI handles architecture (Pilot) and implementation (Gunner)
# You review and approve all PRs before production
```

## 🛠️ Self-Hosted Runner Benefits

**✅ Reliability**: No capacity limits or provider outages  
**✅ Performance**: Choose hardware that fits your models (1B to 70B+)  
**✅ Cost Control**: Use free cloud, paid cloud, or local hardware  
**✅ Model Persistence**: Downloaded models stay cached  
**✅ Customization**: Install any models, tools, or dependencies  

## 🤖 AI Model Requirements

**Minimum Configuration:**
- **8GB RAM**: 3B-7B models (Llama 3.2 3B, Qwen 2.5 7B)
- **16GB RAM**: 7B-8B models (Llama 3.2 8B, CodeLlama 7B)
- **32GB+ RAM**: 13B+ models (Llama 3.1 13B, CodeLlama 13B)

**Model Recommendations:**
- **Commander**: `llama3.2:8b-instruct` (strategic reasoning)
- **Pilot**: `qwen2.5:7b-instruct` (technical architecture)
- **Gunner**: `codellama:7b-instruct` (code implementation)

## 📚 Documentation

- [Runner Setup Guide](./docs/runner-setup.md) - Detailed installation instructions
- [Workflow Reference](./docs/workflows.md) - GitHub Actions configuration
- [System Prompts](./system-prompts/) - Ready-to-use AI role definitions
- [Example Projects](./examples/) - Sample implementations
- [Troubleshooting](./docs/troubleshooting.md) - Common issues and solutions

## 🔧 System Prompts

The repository includes optimized system prompts for each role:

- [`system-prompts/commander.md`](./system-prompts/commander.md) - Strategic oversight
- [`system-prompts/pilot.md`](./system-prompts/pilot.md) - Architecture & planning
- [`system-prompts/gunner.md`](./system-prompts/gunner.md) - Implementation & testing

## 🎮 Your Role as Commander

### Strategic Decision Making
As the human Commander, you make all strategic decisions:
- **What** features to build and when
- **Why** they align with project goals  
- **Whether** the AI implementation meets your standards
- **When** code is ready for production

### Workflow Example
```bash
# 1. You decide what to build
gh workflow run cylon-development.yml \
  -f feature_description="user authentication" \
  -f priority="high" \
  -f commander_approval="approved"

# 2. AI Pilot designs architecture
# 3. AI Gunner implements code
# 4. You review both PRs before merging
```

### Review Checklist
When reviewing AI-generated code:
- [ ] Does this solve the right problem?
- [ ] Is the architecture sound and maintainable?
- [ ] Are tests comprehensive and meaningful?
- [ ] Is documentation clear and complete?
- [ ] Will this integrate well with existing code?

*See `system-prompts/commander.md` for detailed guidance.*

## 🎮 Example Workflows

### Feature Development
```bash
# Start a new feature
gh workflow run feature-development.yml \
  -f feature="user authentication" \
  -f priority="high"
```

### Code Review
```bash
# AI-assisted code review
gh workflow run code-review.yml \
  -f pr_number="123"
```

### Architecture Planning
```bash
# System design session
gh workflow run architecture-session.yml \
  -f requirements="scalable user management system"
```

## 🌟 Philosophy

*"What if we could harness organizational efficiency while maintaining human oversight and control? What if the very structure that made the Cylons formidable opponents could be adopted to make AI our most effective collaborators?"*

This project explores disciplined AI collaboration through:
- **Clear role boundaries** between human and AI responsibilities
- **Quality gates** that prevent poor code from reaching production
- **Reproducible workflows** that work regardless of cloud provider availability
- **Human strategic oversight** that learns from the cautionary tale rather than repeating it

## 🤝 Contributing

1. **Fork the repository**
2. **Set up your self-hosted runner** 
3. **Test the methodology** on real projects
4. **Share improvements** via pull requests

## 📄 License

MIT License - Use freely for personal and commercial projects.

---

**Ready to command your own Cylon Raider development team?**

Start with: `./runner-setup/setup-local-runner.sh`
