#!/bin/bash

# Q-SPEC Kit Setup Script
# Sets up dev-agent with dynamic path resolution

set -e

# ============================================================================
# Configuration
# ============================================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Get absolute path of current directory
REPO_PATH=$(pwd)
AGENTS_DIR="$HOME/.kiro/agents"
TEMPLATE_PATH=""  # Will be set by select_template()

# ============================================================================
# Utility Functions
# ============================================================================

print_header() {
    echo
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

prompt_yes_no() {
    local prompt="$1"
    local default="${2:-Y}"
    
    if [ "$default" = "Y" ]; then
        echo -en "${YELLOW}${prompt} (Y/n): ${NC}" >&2
    else
        echo -en "${YELLOW}${prompt} (y/N): ${NC}" >&2
    fi
    
    read -r response
    if [ "$default" = "Y" ]; then
        [[ ! "$response" =~ ^[Nn]$ ]]
    else
        [[ "$response" =~ ^[Yy]$ ]]
    fi
}

prompt_input() {
    local prompt="$1"
    local default="$2"
    local result
    
    if [ -n "$default" ]; then
        echo -en "${YELLOW}${prompt} (default: ${default}): ${NC}" >&2
    else
        echo -en "${YELLOW}${prompt}: ${NC}" >&2
    fi
    
    read -r result
    if [ -z "$result" ] && [ -n "$default" ]; then
        result="$default"
    fi
    
    # Return the result via stdout
    echo "$result"
}

# ============================================================================
# Setup Functions
# ============================================================================

check_prerequisites() {
    print_header "🔍 Checking Prerequisites"
    
    # Check if templates directory exists
    if [ ! -d "${REPO_PATH}/templates" ]; then
        print_error "Templates directory not found: ${REPO_PATH}/templates"
        exit 1
    fi
    
    # Check if any templates exist
    local template_count=$(find "${REPO_PATH}/templates" -name "*.json.template" | wc -l | tr -d ' ')
    if [ "$template_count" -eq 0 ]; then
        print_error "No templates found in ${REPO_PATH}/templates"
        exit 1
    fi
    print_success "Found ${template_count} template(s)"
    
    # Check if jq is installed
    if ! command -v jq &> /dev/null; then
        print_error "jq is not installed. Please install it first."
        exit 1
    fi
    print_success "jq is installed"
    
    # Create agents directory
    mkdir -p "$AGENTS_DIR"
    print_success "Agents directory ready"
}

select_template() {
    print_header "📋 Template Selection"
    
    # Find all templates
    local templates=()
    while IFS= read -r template_path; do
        templates+=("$template_path")
    done < <(find "${REPO_PATH}/templates" -name "*.json.template" | sort)
    
    if [ ${#templates[@]} -eq 1 ]; then
        TEMPLATE_PATH="${templates[0]}"
        local template_name=$(basename "$TEMPLATE_PATH" .json.template)
        print_info "Using template: ${template_name}"
        return
    fi
    
    echo "Available templates:"
    echo
    local i=1
    for template_path in "${templates[@]}"; do
        local template_name=$(basename "$template_path" .json.template)
        # Convert kebab-case to Title Case for display
        local display_name=$(echo "$template_name" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2));}1')
        echo "  ${i}) ${display_name}"
        ((i++))
    done
    echo
    
    local choice=$(prompt_input "Select template (1-${#templates[@]})" "1")
    echo  # Add newline after input
    
    # Validate choice
    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt ${#templates[@]} ]; then
        print_warning "Invalid choice. Using first template."
        choice=1
    fi
    
    TEMPLATE_PATH="${templates[$((choice-1))]}"
    local template_name=$(basename "$TEMPLATE_PATH" .json.template)
    print_success "Selected template: ${template_name}"
}

show_existing_agents() {
    print_header "📋 Existing Agents"
    
    if [ -d "$AGENTS_DIR" ] && [ "$(ls -A "$AGENTS_DIR"/*.json 2>/dev/null)" ]; then
        ls -1 "$AGENTS_DIR"/*.json 2>/dev/null | while read -r agent_file; do
            agent_name=$(basename "$agent_file" .json)
            echo "  • ${agent_name}"
        done
    else
        echo "  (No existing agents)"
    fi
}

setup_agent_name() {
    print_header "🤖 Agent Configuration"
    
    agent_name=$(prompt_input "Enter agent name" "dev-agent")
    AGENT_PATH="${AGENTS_DIR}/${agent_name}.json"
    
    # Check if agent already exists
    if [ -f "$AGENT_PATH" ]; then
        if ! prompt_yes_no "Agent '${agent_name}' already exists. Overwrite?" "N"; then
            echo  # Add newline after input
            print_error "Setup cancelled"
            exit 1
        fi
        echo  # Add newline after input
    fi
    
    echo  # Add newline before info message
    print_info "Agent will be created at: ${AGENT_PATH}"
}

setup_mcp_servers() {
    print_header "🔌 MCP Server Configuration"
    
    if ! prompt_yes_no "Add MCP servers?" "Y"; then
        echo  # Add newline after input
        print_info "Skipping MCP server setup"
        MCP_JSON="{}"
        MCP_TOOLS=""
        MCP_ALLOWED_TOOLS=""
        return
    fi
    echo  # Add newline after input
    
    local MCP_CONFIG_FILE="${REPO_PATH}/mcp_servers.json"
    if [ ! -f "$MCP_CONFIG_FILE" ]; then
        print_warning "MCP configuration file not found: ${MCP_CONFIG_FILE}"
        MCP_JSON="{}"
        MCP_ALLOWED_TOOLS=""
        return
    fi
    
    # Get default MCPs
    local default_mcps=$(jq -r '.default[]' "$MCP_CONFIG_FILE")
    
    # Show available MCP servers with letter labels
    echo "Available MCP servers:"
    echo
    
    local mcp_keys=$(jq -r '.recommended | keys[]' "$MCP_CONFIG_FILE" | sort)
    local letters=("a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z")
    declare -a mcp_keys_array
    local default_letters=""
    local idx=0
    
    for key in $mcp_keys; do
        local letter="${letters[$idx]}"
        local desc=$(jq -r ".recommended.\"$key\".description" "$MCP_CONFIG_FILE")
        
        # Check if this is a default MCP
        local is_default=""
        for default_mcp in $default_mcps; do
            if [ "$key" = "$default_mcp" ]; then
                is_default=" ${GREEN}✓${NC}"
                default_letters="${default_letters}${letter}"
                break
            fi
        done
        
        echo -e "  ${letter}. [${key}] ${desc}${is_default}"
        mcp_keys_array+=("$key")
        ((idx++))
    done
    echo
    echo -e "${CYAN}${GREEN}✓${NC} = recommended${NC}"
    echo
    
    echo "Enter letters to select (e.g., 'ab' for a+b), or press Enter for recommended:"
    local selection=$(prompt_input "Selection" "$default_letters")
    echo  # Add newline after input
    
    # Parse selection
    declare -a selected_mcps
    if [ -z "$selection" ]; then
        # Use default
        selection="$default_letters"
    fi
    
    # Convert selection string to array of MCPs
    for (( i=0; i<${#selection}; i++ )); do
        local letter="${selection:$i:1}"
        # Convert letter to index (a=0, b=1, etc.)
        local letter_idx=$(($(printf '%d' "'$letter") - 97))
        
        if [ $letter_idx -ge 0 ] && [ $letter_idx -lt ${#mcp_keys_array[@]} ]; then
            selected_mcps+=("${mcp_keys_array[$letter_idx]}")
        else
            print_warning "Invalid selection: ${letter}"
        fi
    done
    
    # Remove duplicates
    selected_mcps=($(printf "%s\n" "${selected_mcps[@]}" | sort -u))
    
    # Check Docker dependency for searxng
    for key in "${selected_mcps[@]}"; do
        if [ "$key" = "searxng" ]; then
            if ! command -v docker &> /dev/null; then
                print_error "Docker is required for SearXNG but not installed"
                print_info "Install Docker: https://docs.docker.com/get-docker/"
                exit 1
            fi
            if ! docker compose version &> /dev/null; then
                print_error "Docker Compose is required for SearXNG but not available"
                print_info "Install Docker Compose: https://docs.docker.com/compose/install/"
                exit 1
            fi
            print_success "Docker and Docker Compose are installed"
            break
        fi
    done
    
    # Build MCP servers JSON, tools array, and allowed tools
    if [ ${#selected_mcps[@]} -gt 0 ]; then
        MCP_JSON="{"
        MCP_TOOLS=""
        MCP_ALLOWED_TOOLS=""
        local first=true
        local first_allowed=true
        
        echo "Selected MCP servers:"
        for key in "${selected_mcps[@]}"; do
            echo "  • ${key}"
            
            if [ "$first" = false ]; then
                MCP_JSON="${MCP_JSON},"
                MCP_TOOLS="${MCP_TOOLS},"
            fi
            first=false
            
            local name=$(jq -r ".recommended.\"$key\".name" "$MCP_CONFIG_FILE")
            local config=$(jq -c ".recommended.\"$key\".config" "$MCP_CONFIG_FILE" | sed "s|{{REPO_PATH}}|${REPO_PATH}|g")
            MCP_JSON="${MCP_JSON}\"${name}\":${config}"
            MCP_TOOLS="${MCP_TOOLS}\"@${name}\""
            
            # Collect recommended allowed tools
            local allowed_tools=$(jq -r ".recommended.\"$key\".recommended_allowed_tools // [] | .[]" "$MCP_CONFIG_FILE")
            for tool in $allowed_tools; do
                if [ "$first_allowed" = false ]; then
                    MCP_ALLOWED_TOOLS="${MCP_ALLOWED_TOOLS},"
                fi
                first_allowed=false
                MCP_ALLOWED_TOOLS="${MCP_ALLOWED_TOOLS}\"${tool}\""
            done
        done
        MCP_JSON="${MCP_JSON}}"
        echo
        print_success "Configured ${#selected_mcps[@]} MCP server(s)"
    else
        MCP_JSON="{}"
        MCP_TOOLS=""
        MCP_ALLOWED_TOOLS=""
        print_info "No MCP servers selected"
    fi
}

setup_language() {
    print_header "🌐 Language Configuration"
    
    echo "Select your preferred language:"
    echo "  1) English"
    echo "  2) 日本語 (Japanese)"
    echo
    
    local lang_choice=$(prompt_input "Enter choice (1 or 2)" "1")
    
    echo  # Add newline before processing
    
    case $lang_choice in
        1)
            LANG_CODE="en"
            LANG_NAME="English"
            ;;
        2)
            LANG_CODE="ja"
            LANG_NAME="Japanese"
            ;;
        *)
            print_warning "Invalid choice. Defaulting to English"
            LANG_CODE="en"
            LANG_NAME="English"
            ;;
    esac
    
    print_success "Language set to: ${LANG_NAME}"
}

setup_user_name() {
    print_header "👤 User Configuration"
    
    echo "Your name will be used in SPEC file management (e.g., closing SPECs to your folder)."
    echo "You can leave it empty and set it later in user_preference.md"
    echo
    
    # Get system username as default
    local default_name=$(whoami)
    
    USER_NAME=$(prompt_input "Enter your name" "$default_name")
    
    echo  # Add newline before processing
    
    if [ -z "$USER_NAME" ]; then
        print_warning "No user name provided. You can set it later in user_preference.md"
    else
        print_success "User name set to: ${USER_NAME}"
    fi
}

generate_user_preference() {
    local user_pref_file="${REPO_PATH}/contexts/user_preference_${agent_name}.md"
    
    print_header "📝 Generating User Preference File"
    
    # Check if file already exists
    if [ -f "$user_pref_file" ]; then
        print_warning "User preference file already exists: ${user_pref_file}"
        if ! prompt_yes_no "Overwrite it?" "N"; then
            echo  # Add newline after input
            print_info "Keeping existing user preference file"
            return
        fi
        echo  # Add newline after input
    fi
    
    cat > "$user_pref_file" << EOF
<!-- Q-SPEC Kitを改善する場合は必ずこのファイルにルールを追加する。他のコンテキストには変更を加えない。 -->
EOF

    if [ "$LANG_CODE" = "ja" ]; then
        cat >> "$user_pref_file" << EOF
- エージェントは**必ず**日本語でレスポンスを行うこと。
EOF
    fi

    if [ -n "$USER_NAME" ]; then
        cat >> "$user_pref_file" << EOF
- User name is "${USER_NAME}". **Use this name for SPEC management**.
EOF
    fi

    print_success "User preference file created: ${user_pref_file}"
}

generate_agent_config() {
    print_header "⚙️  Generating Agent Configuration"
    
    # Replace placeholders with actual values
    sed -e "s|{{REPO_PATH}}|${REPO_PATH}|g" \
        -e "s|{{AGENT_NAME}}|${agent_name}|g" \
        "$TEMPLATE_PATH" > "$AGENT_PATH.tmp"
    
    # Replace mcpServers
    jq --argjson mcp "$MCP_JSON" '.mcpServers = $mcp' "$AGENT_PATH.tmp" > "$AGENT_PATH.tmp2"
    
    # Add MCP tools to tools array if any
    if [ -n "$MCP_TOOLS" ]; then
        jq --argjson mcpTools "[$MCP_TOOLS]" '.tools += $mcpTools' "$AGENT_PATH.tmp2" > "$AGENT_PATH.tmp3"
    else
        mv "$AGENT_PATH.tmp2" "$AGENT_PATH.tmp3"
    fi
    
    # Add MCP allowed tools to allowedTools array if any
    if [ -n "$MCP_ALLOWED_TOOLS" ]; then
        jq --argjson allowedTools "[$MCP_ALLOWED_TOOLS]" '.allowedTools += $allowedTools' "$AGENT_PATH.tmp3" > "$AGENT_PATH"
    else
        mv "$AGENT_PATH.tmp3" "$AGENT_PATH"
    fi
    
    # Cleanup temp files
    rm -f "$AGENT_PATH.tmp" "$AGENT_PATH.tmp2" "$AGENT_PATH.tmp3"
    
    # Verify generated file
    if [ ! -f "$AGENT_PATH" ]; then
        print_error "Failed to generate agent configuration"
        exit 1
    fi
    
    print_success "Agent configuration generated"
}

verify_contexts() {
    print_header "🔍 Verifying Context Files"
    
    if [ ! -d "${REPO_PATH}/contexts" ]; then
        print_error "Contexts directory not found: ${REPO_PATH}/contexts"
        exit 1
    fi
    
    # Context files are always in English (AI can handle output language via user_preference)
    local required_contexts=(
        "git_rules.md"
        "spec_rules_en.md"
        "Q-SPEC Framework_en.md"
        "tips.md"
    )
    
    local missing_contexts=()
    for context in "${required_contexts[@]}"; do
        if [ ! -f "${REPO_PATH}/contexts/${context}" ]; then
            missing_contexts+=("$context")
        fi
    done
    
    if [ ${#missing_contexts[@]} -gt 0 ]; then
        print_warning "Some context files are missing:"
        for context in "${missing_contexts[@]}"; do
            echo "  • ${context}"
        done
        echo
        if ! prompt_yes_no "Continue anyway?" "Y"; then
            echo  # Add newline after input
            print_error "Setup cancelled"
            exit 1
        fi
        echo  # Add newline after input
    else
        print_success "All required context files found"
    fi
}

setup_alias() {
    print_header "🔧 Shell Alias Setup"
    
    if ! prompt_yes_no "Set up a shell alias for 'kiro-cli chat --agent ${agent_name}'?" "Y"; then
        echo  # Add newline after input
        print_info "Skipping alias setup"
        return
    fi
    echo  # Add newline after input
    
    # Detect current shell
    local current_shell=$(basename "$SHELL")
    print_info "Detected shell: ${current_shell}"
    
    # Determine shell config file
    local shell_config=""
    case "$current_shell" in
        "zsh")
            shell_config="$HOME/.zshrc"
            ;;
        "bash")
            if [ -f "$HOME/.bashrc" ]; then
                shell_config="$HOME/.bashrc"
            else
                shell_config="$HOME/.bash_profile"
            fi
            ;;
        "fish")
            shell_config="$HOME/.config/fish/config.fish"
            ;;
        *)
            print_warning "Unknown shell: ${current_shell}"
            ;;
    esac
    
    if [ -z "$shell_config" ]; then
        print_warning "Could not determine shell config file"
        echo -e "${CYAN}💡 Manually add this alias to your shell config:${NC}"
        echo -e "${GREEN}alias your_alias='kiro-cli chat --agent ${agent_name}'${NC}"
        return
    fi
    
    # Get alias name
    local alias_name=$(prompt_input "Enter alias name" "qcd")
    echo  # Add newline after input
    
    local alias_line="alias ${alias_name}='kiro-cli chat --agent ${agent_name}'"
    
    # Check if alias already exists
    if [ -f "$shell_config" ] && grep -q "alias ${alias_name}=" "$shell_config"; then
        print_warning "Alias '${alias_name}' already exists in ${shell_config}"
        if prompt_yes_no "Update it?" "N"; then
            echo  # Add newline after input
            # Remove existing alias and add new one
            grep -v "alias ${alias_name}=" "$shell_config" > "${shell_config}.tmp" && mv "${shell_config}.tmp" "$shell_config"
            echo "$alias_line" >> "$shell_config"
            print_success "Alias '${alias_name}' updated in ${shell_config}"
            ALIAS_NAME="$alias_name"
            SHELL_CONFIG="$shell_config"
        else
            echo  # Add newline after input
            print_info "Skipping alias update"
        fi
    else
        if prompt_yes_no "Add alias '${alias_name}' to ${shell_config}?" "Y"; then
            echo  # Add newline after input
            echo "$alias_line" >> "$shell_config"
            print_success "Alias '${alias_name}' added to ${shell_config}"
            echo -e "${CYAN}💡 Run 'source ${shell_config}' or restart your terminal to use the alias${NC}"
            ALIAS_NAME="$alias_name"
            SHELL_CONFIG="$shell_config"
        else
            echo  # Add newline after input
            print_info "Skipping alias setup"
        fi
    fi
}

show_summary() {
    print_header "📊 Setup Summary"
    
    echo "Agent Name:       ${agent_name}"
    echo "Agent Path:       ${AGENT_PATH}"
    echo "Language:         ${LANG_NAME}"
    if [ -n "$USER_NAME" ]; then
        echo "User Name:        ${USER_NAME}"
    fi
    echo "Repository Path:  ${REPO_PATH}"
    if [ -n "$ALIAS_NAME" ]; then
        echo "Shell Alias:      ${ALIAS_NAME}"
    fi
    echo
    
    print_success "Setup completed successfully!"
    echo
    echo -e "${CYAN}Next steps:${NC}"
    echo "  1. Start using your agent:"
    echo -e "     ${GREEN}kiro-cli chat --agent ${agent_name}${NC}"
    if [ -n "$ALIAS_NAME" ] && [ -n "$SHELL_CONFIG" ]; then
        echo -e "     ${GREEN}${ALIAS_NAME}${NC} (after sourcing shell config)"
    fi
    echo
    echo "  2. Customize your agent configuration:"
    echo -e "     ${GREEN}vim ${AGENT_PATH}${NC}"
    echo
    echo "  3. Update user preferences:"
    echo -e "     ${GREEN}vim ${REPO_PATH}/contexts/user_preference_${agent_name}.md${NC}"
    
    if [ -n "$SHELL_CONFIG" ]; then
        echo
        echo -e "${CYAN}💡 To activate the alias now:${NC}"
        echo -e "   ${GREEN}source ${SHELL_CONFIG}${NC}"
    fi
}

# ============================================================================
# Main Execution
# ============================================================================

main() {
    echo -e "${BLUE}🚀 Q-SPEC Kit Setup${NC}"
    echo "Setting up dev-agent with Q-SPEC Kit..."
    echo
    print_info "Repository path: ${REPO_PATH}"
    
    check_prerequisites
    select_template
    show_existing_agents
    setup_agent_name
    setup_mcp_servers
    setup_language
    setup_user_name
    generate_user_preference
    generate_agent_config
    verify_contexts
    setup_alias
    show_summary
}

# Run main function
main
