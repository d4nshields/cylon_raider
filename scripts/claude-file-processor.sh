#!/bin/bash
# claude-file-processor.sh - Process Claude API responses into actual files
# Handles structured responses and file creation from Claude's output

process_claude_response() {
    local response_text="$1"
    local work_dir="${2:-.}"
    
    echo "🔧 Processing Claude response for file operations..."
    
    # Create work directory if it doesn't exist
    mkdir -p "$work_dir"
    cd "$work_dir"
    
    # Write response to temporary file for processing
    echo "$response_text" > /tmp/claude_response.txt
    
    # State variables
    local current_file=""
    local in_code_block=false
    local files_created=0
    
    # Process line by line
    while IFS= read -r line; do
        # Check for file creation patterns
        if [[ "$line" =~ ^#+[[:space:]]*([^[:space:]]+\.(py|js|ts|md|txt|json|yaml|yml|sh|html|css|sql|env))$ ]]; then
            # Extract filename from markdown header
            current_file=$(echo "$line" | sed -E 's/^#+[[:space:]]*([^[:space:]]+\.(py|js|ts|md|txt|json|yaml|yml|sh|html|css|sql|env))$/\1/')
            echo "📄 Creating file: $current_file"
            mkdir -p "$(dirname "$current_file")"
            # Clear the file
            > "$current_file"
            files_created=$((files_created + 1))
            in_code_block=false
            
        elif [[ "$line" =~ ^[[:space:]]*\`\`\`[[:space:]]*[a-zA-Z]*[[:space:]]*$ ]]; then
            # Start or end of code block
            if [ "$in_code_block" = true ]; then
                in_code_block=false
            else
                in_code_block=true
            fi
            
        elif [ "$in_code_block" = true ] && [ -n "$current_file" ]; then
            # Inside code block - append to current file
            echo "$line" >> "$current_file"
            
        elif [[ "$line" =~ ^[[:space:]]*#[[:space:]]*File:[[:space:]]*(.+)$ ]] || [[ "$line" =~ ^[[:space:]]*\/\/[[:space:]]*File:[[:space:]]*(.+)$ ]]; then
            # Alternative file specification format
            current_file=$(echo "$line" | sed -E 's/^[[:space:]]*[#\/\/]+[[:space:]]*File:[[:space:]]*(.+)$/\1/')
            echo "📄 Creating file: $current_file"
            mkdir -p "$(dirname "$current_file")"
            > "$current_file"
            files_created=$((files_created + 1))
            in_code_block=false
        fi
        
    done < /tmp/claude_response.txt
    
    # If no files were created, try to extract any code blocks into sensible files
    if [ $files_created -eq 0 ]; then
        echo "🔍 No explicit files found, extracting code blocks..."
        
        local block_count=0
        local in_code=false
        local code_lang=""
        
        while IFS= read -r line; do
            if [[ "$line" =~ ^[[:space:]]*\`\`\`([[:space:]]*[a-zA-Z]+)?[[:space:]]*$ ]]; then
                if [ "$in_code" = true ]; then
                    # End of code block
                    in_code=false
                else
                    # Start of code block
                    in_code=true
                    code_lang=$(echo "$line" | sed -E 's/^[[:space:]]*```[[:space:]]*([a-zA-Z]+)?[[:space:]]*$/\1/')
                    block_count=$((block_count + 1))
                    
                    # Determine file extension
                    case "$code_lang" in
                        python|py) current_file="code_${block_count}.py" ;;
                        javascript|js) current_file="code_${block_count}.js" ;;
                        typescript|ts) current_file="code_${block_count}.ts" ;;
                        bash|shell|sh) current_file="code_${block_count}.sh" ;;
                        html) current_file="code_${block_count}.html" ;;
                        css) current_file="code_${block_count}.css" ;;
                        sql) current_file="code_${block_count}.sql" ;;
                        json) current_file="code_${block_count}.json" ;;
                        yaml|yml) current_file="code_${block_count}.yml" ;;
                        *) current_file="code_${block_count}.txt" ;;
                    esac
                    
                    echo "📄 Extracting $code_lang code to: $current_file"
                    > "$current_file"
                    files_created=$((files_created + 1))
                fi
            elif [ "$in_code" = true ] && [ -n "$current_file" ]; then
                echo "$line" >> "$current_file"
            fi
        done < /tmp/claude_response.txt
    fi
    
    # Clean up
    rm -f /tmp/claude_response.txt
    
    echo "✅ Processed Claude response: $files_created files created"
    
    if [ $files_created -gt 0 ]; then
        echo "📋 Created files:"
        find . -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.md" -o -name "*.txt" -o -name "*.json" -o -name "*.yml" -o -name "*.yaml" -o -name "*.sh" -o -name "*.html" -o -name "*.css" -o -name "*.sql" | head -10 | while read file; do
            echo "  - $file ($(wc -l < "$file") lines)"
        done
    fi
    
    return 0
}

# If script is called directly (not sourced), run the function
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [ $# -lt 1 ]; then
        echo "Usage: $0 <response_text> [work_dir]"
        exit 1
    fi
    process_claude_response "$1" "$2"
fi
