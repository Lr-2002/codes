#!/bin/bash

# Claude Code Custom Tools Update Script
# This script updates existing custom commands, settings, and dependencies for Claude Code

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
BACKUP_DIR="$HOME/.claude/backup_update_$(date +%Y%m%d_%H%M%S)"

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

# Check if installation exists
check_installation() {
    if [ ! -f "$CLAUDE_DIR/project_info.json" ]; then
        print_error "Claude Code Custom Tools not found. Please run install.sh first."
        exit 1
    fi

    print_info "Found existing installation"
    if [ -f "$CLAUDE_DIR/project_info.json" ]; then
        local install_date=$(jq -r '.install_date' "$CLAUDE_DIR/project_info.json" 2>/dev/null || echo "Unknown")
        print_info "Previous installation: $install_date"
    fi
}

# Create backup before update
backup_before_update() {
    print_info "Creating backup before update..."
    mkdir -p "$BACKUP_DIR"

    # Backup existing commands
    if [ -d "$CLAUDE_DIR/commands" ]; then
        cp -r "$CLAUDE_DIR/commands" "$BACKUP_DIR/"
        print_success "Commands backed up"
    fi

    # Backup existing settings
    if [ -f "$CLAUDE_DIR/settings.local.json" ]; then
        cp "$CLAUDE_DIR/settings.local.json" "$BACKUP_DIR/"
        print_success "Settings backed up"
    fi

    # Backup project info
    if [ -f "$CLAUDE_DIR/project_info.json" ]; then
        cp "$CLAUDE_DIR/project_info.json" "$BACKUP_DIR/"
        print_success "Project info backed up"
    fi
}

# Update commands
update_commands() {
    print_info "Updating custom slash commands..."

    if [ -d "$SCRIPT_DIR/commands" ]; then
        # Remove old command files
        if [ -d "$CLAUDE_DIR/commands" ]; then
            rm -f "$CLAUDE_DIR/commands"/*.md
        fi

        # Copy new command files
        mkdir -p "$CLAUDE_DIR/commands"
        cp -v "$SCRIPT_DIR"/commands/*.md "$CLAUDE_DIR/commands/" 2>/dev/null || {
            print_warning "No command files found in commands/ directory"
        }

        local command_count=$(ls -1 "$CLAUDE_DIR/commands"/*.md 2>/dev/null | wc -l)
        print_success "Updated $command_count command files"
    else
        print_warning "Commands directory not found"
    fi
}

# Update settings
update_settings() {
    print_info "Updating Claude Code settings..."

    if [ -f "$SCRIPT_DIR/.claude/settings.local.json" ]; then
        # Create .claude directory if it doesn't exist
        mkdir -p "$CLAUDE_DIR"

        # Backup current settings before updating
        if [ -f "$CLAUDE_DIR/settings.local.json" ]; then
            cp "$CLAUDE_DIR/settings.local.json" "$BACKUP_DIR/settings.local.json.pre-update"
        fi

        # Copy new settings
        cp "$SCRIPT_DIR/.claude/settings.local.json" "$CLAUDE_DIR/settings.local.json"
        print_success "Settings updated"
    else
        print_warning "Settings file not found at .claude/settings.local.json"
    fi
}

# Update dependencies
update_dependencies() {
    print_info "Updating dependencies..."

    if [ -f "$SCRIPT_DIR/install_depency.sh" ]; then
        print_info "Running dependency update script..."

        # Make script executable
        chmod +x "$SCRIPT_DIR/install_depency.sh"

        # Run the dependency script
        cd "$SCRIPT_DIR"
        ./install_depency.sh
        cd - > /dev/null

        print_success "Dependencies updated"
    else
        print_warning "Dependency installation script not found"
    fi
}

# Update project configuration
update_project_config() {
    print_info "Updating project configuration..."

    # Read old version if exists
    local old_version="1.0.0"
    if [ -f "$CLAUDE_DIR/project_info.json" ]; then
        old_version=$(jq -r '.version // "1.0.0"' "$CLAUDE_DIR/project_info.json" 2>/dev/null || echo "1.0.0")
    fi

    # Create new project config
    cat > "$CLAUDE_DIR/project_info.json" << EOF
{
  "project_name": "Claude Code Custom Tools",
  "install_date": "$(jq -r '.install_date // "'$(date -Iseconds)'"' "$CLAUDE_DIR/project_info.json" 2>/dev/null || echo "$(date -Iseconds)")",
  "last_update": "$(date -Iseconds)",
  "source_directory": "$SCRIPT_DIR",
  "version": "1.0.0",
  "previous_version": "$old_version",
  "components": {
    "commands": true,
    "settings": true,
    "dependencies": true
  },
  "update_history": [
    {
      "date": "$(date -Iseconds)",
      "previous_version": "$old_version",
      "new_version": "1.0.0"
    }
  ]
}
EOF

    print_success "Project configuration updated"
}

# Show update summary
show_update_summary() {
    echo
    print_success "🔄 Update completed successfully!"
    echo
    print_info "What was updated:"
    echo "  • Custom slash commands in $CLAUDE_DIR/commands/"
    echo "  • Settings configuration in $CLAUDE_DIR/settings.local.json"
    echo "  • Project metadata in $CLAUDE_DIR/project_info.json"
    echo
    print_info "Backup created at: $BACKUP_DIR"
    print_info "To rollback changes, restore files from the backup directory"
    echo
    print_info "Updated commands available after restarting Claude Code:"
    echo "  /commit    - Create conventional commits with emoji"
    echo "  /update_commands    - Update command documentation"
}

# Main update function
main() {
    print_info "Starting Claude Code Custom Tools update..."
    print_info "Source directory: $SCRIPT_DIR"
    print_info "Target directory: $CLAUDE_DIR"

    # Check if installation exists
    check_installation

    # Create backup
    backup_before_update

    # Update components
    update_commands
    update_settings
    update_dependencies
    update_project_config

    # Show summary
    show_update_summary
}

# Parse command line arguments
FORCE_UPDATE=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --force|-f)
            FORCE_UPDATE=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo
            echo "Options:"
            echo "  --force, -f    Force update without checking installation"
            echo "  --help, -h     Show this help message"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Check if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi