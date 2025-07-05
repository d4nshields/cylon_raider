#!/bin/bash
# make-scripts-executable.sh
# Makes all shell scripts executable

echo "🔧 Making scripts executable..."

# Find and make executable all .sh files in the project
find . -name "*.sh" -type f -exec chmod +x {} \;

echo "✅ All shell scripts are now executable:"
find . -name "*.sh" -type f -exec ls -la {} \; | awk '{print $1, $9}'

echo ""
echo "🚀 Ready to use:"
echo "• ./runner-setup/setup-local-runner.sh"
echo "• ./runner-setup/setup-cloud-runner.sh" 
echo "• ./runner-setup/setup-oracle-runner.sh"
echo "• ./scripts/test-cylon-roles.sh"
echo "• ./scripts/monitor-runner.sh"
echo "• ./scripts/project-summary.sh"
