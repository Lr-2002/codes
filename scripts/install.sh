#!/bin/bash

# Claude Code Custom Tools Installation Script
# This script installs custom commands, settings, and dependencies for Claude Code

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"
BACKUP_DIR="$HOME/.claude/backup_$(date +%Y%m%d_%H%M%S)"

# Helper functions
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Create backup of existing Claude Code settings
backup_existing() {
    if [ -d "$CLAUDE_DIR" ] && [ "$(ls -A "$CLAUDE_DIR" 2>/dev/null)" ]; then
        print_info "Creating backup of existing Claude Code settings..."
        mkdir -p "$BACKUP_DIR"
        cp -r "$CLAUDE_DIR/"* "$BACKUP_DIR/" 2>/dev/null || true
        print_success "Backup created at $BACKUP_DIR"
    fi
}

# Install custom commands
install_commands() {
    print_info "Installing custom slash commands..."

    # Create commands directory
    mkdir -p "$CLAUDE_DIR/commands"

    # Copy all command markdown files
    if [ -d "$SCRIPT_DIR/commands" ]; then
        cp -v "$SCRIPT_DIR"/commands/*.md "$CLAUDE_DIR/commands/" 2>/dev/null || {
            print_warning "No command files found in commands/ directory"
        }
        print_success "Custom commands installed to $CLAUDE_DIR/commands/"
    else
        print_warning "Commands directory not found"
    fi
}

# Install settings
install_settings() {
    print_info "Installing Claude Code settings..."

    # Create .claude directory if it doesn't exist
    mkdir -p "$CLAUDE_DIR"

    # Install main settings.json
    if [ -f "$SCRIPT_DIR/settings.json" ]; then
        # Backup existing settings if they exist
        if [ -f "$CLAUDE_DIR/settings.json" ]; then
            cp "$CLAUDE_DIR/settings.json" "$BACKUP_DIR/settings.json.backup" 2>/dev/null || true
            print_warning "Existing main settings backed up"
        fi

        # Copy new settings
        cp "$SCRIPT_DIR/settings.json" "$CLAUDE_DIR/settings.json"
        print_success "Main settings installed to $CLAUDE_DIR/settings.json"
    else
        print_warning "Main settings file not found at settings.json"
    fi

    # Install local settings file
    if [ -f "$SCRIPT_DIR/config/settings.local.json" ]; then
        # Backup existing local settings if they exist
        if [ -f "$CLAUDE_DIR/settings.local.json" ]; then
            cp "$CLAUDE_DIR/settings.local.json" "$BACKUP_DIR/settings.local.json.backup" 2>/dev/null || true
            print_warning "Existing local settings backed up"
        fi

        # Copy new local settings
        cp "$SCRIPT_DIR/config/settings.local.json" "$CLAUDE_DIR/settings.local.json"
        print_success "Local settings installed to $CLAUDE_DIR/settings.local.json"
    else
        print_warning "Local settings file not found at config/settings.local.json"
    fi
}

# Install notifier
install_notifier() {
    print_info "Installing Claude Code notifier..."

    if [ -f "$SCRIPT_DIR/tools/claude-code-notifier.sh" ]; then
        # Copy notifier script
        cp "$SCRIPT_DIR/tools/claude-code-notifier.sh" "$CLAUDE_DIR/claude-code-notifier.sh"
        chmod +x "$CLAUDE_DIR/claude-code-notifier.sh"

        # Install platform-specific dependencies
        case "$(uname -s)" in
            Darwin*)
                if ! command -v terminal-notifier >/dev/null 2>&1; then
                    print_info "Installing terminal-notifier for macOS notifications..."
                    if command -v brew >/dev/null 2>&1; then
                        brew install terminal-notifier
                        print_success "terminal-notifier installed"
                    else
                        print_warning "Homebrew not found. Please install terminal-notifier manually:"
                        echo "  brew install terminal-notifier"
                    fi
                else
                    print_success "terminal-notifier already installed"
                fi
                ;;
            Linux*)
                if ! command -v notify-send >/dev/null 2>&1; then
                    print_info "Installing libnotify-bin for Linux notifications..."
                    if command -v apt >/dev/null 2>&1; then
                        sudo apt update && sudo apt install -y libnotify-bin
                        print_success "libnotify-bin installed"
                    elif command -v yum >/dev/null 2>&1; then
                        sudo yum install -y libnotify
                        print_success "libnotify installed"
                    else
                        print_warning "Package manager not found. Please install notifications manually:"
                        echo "  Ubuntu/Debian: sudo apt install libnotify-bin"
                        echo "  RHEL/CentOS: sudo yum install libnotify"
                    fi
                else
                    print_success "notify-send already installed"
                fi
                ;;
        esac

        # Install jq if not present
        if ! command -v jq >/dev/null 2>&1; then
            print_info "Installing jq for JSON processing..."
            if command -v brew >/dev/null 2>&1; then
                brew install jq
            elif command -v apt >/dev/null 2>&1; then
                sudo apt update && sudo apt install -y jq
            elif command -v yum >/dev/null 2>&1; then
                sudo yum install -y jq
            else
                print_warning "Please install jq manually for the notifier to work properly"
            fi
        else
            print_success "jq already installed"
        fi

        print_success "Claude Code notifier installed"
    else
        print_warning "Notifier script not found"
    fi
}

# Install dependencies
install_dependencies() {
    print_info "Installing dependencies..."

    if [ -f "$SCRIPT_DIR/scripts/install_depency.sh" ]; then
        print_info "Running dependency installation script..."

        # Make script executable
        chmod +x "$SCRIPT_DIR/scripts/install_depency.sh"

        # Run the dependency script
        cd "$SCRIPT_DIR"
        ./scripts/install_depency.sh
        cd - > /dev/null

        print_success "Dependencies installed"
    else
        print_warning "Dependency installation script not found at scripts/install_depency.sh"
    fi
}

# Create project configuration file
create_project_config() {
    print_info "Creating project configuration..."

    cat > "$CLAUDE_DIR/project_info.json" << EOF
{
  "project_name": "Claude Code Custom Tools",
  "install_date": "$(date -Iseconds)",
  "source_directory": "$SCRIPT_DIR",
  "version": "1.0.0",
  "components": {
    "commands": true,
    "settings": true,
    "dependencies": true
  }
}
EOF

    print_success "Project configuration created"
}

# Verify installation
verify_installation() {
    print_info "Verifying installation..."

    local errors=0

    # Check if commands directory exists and has files
    if [ ! -d "$CLAUDE_DIR/commands" ] || [ -z "$(ls -A "$CLAUDE_DIR/commands" 2>/dev/null)" ]; then
        print_error "Commands installation failed"
        ((errors++))
    else
        print_success "Commands installed: $(ls -1 "$CLAUDE_DIR/commands" | wc -l) files"
    fi

    # Check if main settings file exists
    if [ ! -f "$CLAUDE_DIR/settings.json" ]; then
        print_warning "Main settings file not installed"
    else
        print_success "Main settings file installed"
    fi

    # Check if local settings file exists
    if [ ! -f "$CLAUDE_DIR/settings.local.json" ]; then
        print_warning "Local settings file not installed"
    else
        print_success "Local settings file installed"
    fi

    # Check if project info exists
    if [ ! -f "$CLAUDE_DIR/project_info.json" ]; then
        print_error "Project configuration not created"
        ((errors++))
    fi

    if [ $errors -eq 0 ]; then
        print_success "Installation verified successfully"
        return 0
    else
        print_error "Installation completed with $errors errors"
        return 1
    fi
}

# Main installation function
main() {
    print_info "Starting Claude Code Custom Tools installation..."
    print_info "Source directory: $SCRIPT_DIR"
    print_info "Target directory: $CLAUDE_DIR"

    # Create backup
    backup_existing

    # Install components
    install_commands
    install_settings
    install_dependencies
    install_notifier
    create_project_config

    # Verify installation
    if verify_installation; then
        echo
        print_success "🎉 Installation completed successfully!"
        echo
        print_info "What was installed:"
        echo "  • Custom slash commands in $CLAUDE_DIR/commands/"
        echo "  • Main settings configuration in $CLAUDE_DIR/settings.json"
        echo "  • Local settings configuration in $CLAUDE_DIR/settings.local.json"
        echo "  • System notifier in $CLAUDE_DIR/claude-code-notifier.sh"
        echo "  • Project metadata in $CLAUDE_DIR/project_info.json"
        echo
        print_info "To use the custom commands, restart Claude Code and type:"
        echo "  /commit    - Create conventional commits with emoji"
        echo "  /update_commands    - Update command documentation"
        echo
        print_info "System notifications are now enabled for Claude Code events!"
        echo
        print_info "Backup created at: $BACKUP_DIR"
        print_info "To uninstall, run: bash $SCRIPT_DIR/uninstall.sh"
    else
        print_error "Installation failed. Check the messages above."
        exit 1
    fi
}

# Check if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi