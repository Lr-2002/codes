#!/bin/bash

# Claude Code Custom Tools Uninstallation Script
# This script removes custom commands, settings, and dependencies for Claude Code

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
        print_error "Claude Code Custom Tools installation not found."
        print_info "Nothing to uninstall."
        exit 0
    fi

    print_info "Found Claude Code Custom Tools installation"
    if [ -f "$CLAUDE_DIR/project_info.json" ]; then
        local install_date=$(jq -r '.install_date' "$CLAUDE_DIR/project_info.json" 2>/dev/null || echo "Unknown")
        local version=$(jq -r '.version' "$CLAUDE_DIR/project_info.json" 2>/dev/null || echo "Unknown")
        print_info "Installation details: Version $version, installed $install_date"
    fi
}

# Create backup before uninstallation
backup_before_uninstall() {
    local backup_dir="$HOME/.claude/backup_uninstall_$(date +%Y%m%d_%H%M%S)"

    print_info "Creating backup before uninstallation..."
    mkdir -p "$backup_dir"

    # Backup commands
    if [ -d "$CLAUDE_DIR/commands" ]; then
        cp -r "$CLAUDE_DIR/commands" "$backup_dir/"
        print_success "Commands backed up"
    fi

    # Backup settings
    if [ -f "$CLAUDE_DIR/settings.local.json" ]; then
        cp "$CLAUDE_DIR/settings.local.json" "$backup_dir/"
        print_success "Settings backed up"
    fi

    # Backup project info
    if [ -f "$CLAUDE_DIR/project_info.json" ]; then
        cp "$CLAUDE_DIR/project_info.json" "$backup_dir/"
        print_success "Project info backed up"
    fi

    echo "$backup_dir" > "$CLAUDE_DIR/.last_backup_path"
    print_success "Backup created at $backup_dir"
}

# Remove custom commands
remove_commands() {
    print_info "Removing custom slash commands..."

    if [ -d "$CLAUDE_DIR/commands" ]; then
        # Count files before removing
        local file_count=$(ls -1 "$CLAUDE_DIR/commands"/*.md 2>/dev/null | wc -l)

        # Remove only our command files (be conservative)
        local removed_count=0
        for cmd_file in "$SCRIPT_DIR"/commands/*.md; do
            if [ -f "$cmd_file" ]; then
                local cmd_name=$(basename "$cmd_file")
                if [ -f "$CLAUDE_DIR/commands/$cmd_name" ]; then
                    rm "$CLAUDE_DIR/commands/$cmd_name"
                    ((removed_count++))
                    print_info "Removed command: $cmd_name"
                fi
            fi
        done

        # Remove commands directory if empty
        if [ -z "$(ls -A "$CLAUDE_DIR/commands" 2>/dev/null)" ]; then
            rmdir "$CLAUDE_DIR/commands" 2>/dev/null || true
            print_success "Removed empty commands directory"
        else
            print_warning "Commands directory not empty - keeping directory with $(ls -1 "$CLAUDE_DIR/commands" | wc -l) remaining files"
        fi

        print_success "Removed $removed_count command files"
    else
        print_warning "Commands directory not found"
    fi
}

# Remove settings (with user confirmation)
remove_settings() {
    print_warning "Settings removal requires confirmation."
    print_warning "This will remove your Claude Code permissions configuration."

    # Read user input
    read -p "Do you want to remove the settings file? [y/N]: " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ -f "$CLAUDE_DIR/settings.local.json" ]; then
            # Check if we created this settings file
            if grep -q "Bash(git commit:*)" "$CLAUDE_DIR/settings.local.json" 2>/dev/null; then
                rm "$CLAUDE_DIR/settings.local.json"
                print_success "Removed settings file"
            else
                print_warning "Settings file appears to be customized - keeping it"
                print_info "You can manually remove $CLAUDE_DIR/settings.local.json if desired"
            fi
        else
            print_warning "Settings file not found"
        fi
    else
        print_info "Settings file kept as requested"
    fi
}

# Remove project metadata
remove_project_metadata() {
    print_info "Removing project metadata..."

    if [ -f "$CLAUDE_DIR/project_info.json" ]; then
        rm "$CLAUDE_DIR/project_info.json"
        print_success "Removed project metadata"
    fi

    # Remove backup path file
    if [ -f "$CLAUDE_DIR/.last_backup_path" ]; then
        rm "$CLAUDE_DIR/.last_backup_path"
    fi
}

# Clean up dependencies (optional)
cleanup_dependencies() {
    print_warning "Dependency cleanup is not automated."
    print_warning "You may need to manually remove MCP servers if they are no longer needed:"
    echo "  claude mcp list"
    echo "  claude mcp remove <server-name>"
    echo
    print_info "See the backup directory for dependency information"
}

# Show uninstall summary
show_uninstall_summary() {
    local backup_path=""
    if [ -f "$CLAUDE_DIR/.last_backup_path" ]; then
        backup_path=$(cat "$CLAUDE_DIR/.last_backup_path")
    fi

    echo
    print_success "🗑️ Uninstallation completed successfully!"
    echo
    print_info "What was removed:"
    echo "  • Custom slash commands from $CLAUDE_DIR/commands/"
    echo "  • Project metadata from $CLAUDE_DIR/project_info.json"

    if [ -n "$backup_path" ]; then
        echo
        print_info "Backup created at: $backup_path"
        print_info "To restore: cp -r $backup_path/* $CLAUDE_DIR/"
    fi

    echo
    print_info "Next steps:"
    echo "  1. Restart Claude Code to apply changes"
    echo "  2. Review and clean up any remaining MCP servers if needed"
    echo "  3. Check the backup directory before deleting it"

    if [ -n "$backup_path" ]; then
        echo "  4. Backup directory: $backup_path"
    fi
}

# Interactive confirmation
confirm_uninstall() {
    print_warning "This will remove Claude Code Custom Tools from your system."
    print_warning "The following will be affected:"
    echo "  • Custom slash commands (/commit, /update_commands)"
    echo "  • Claude Code settings (permissions, etc.)"
    echo "  • Project metadata and configuration"
    echo

    read -p "Are you sure you want to continue? [y/N]: " -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Uninstallation cancelled by user"
        exit 0
    fi
}

# Main uninstall function
main() {
    print_info "Starting Claude Code Custom Tools uninstallation..."

    # Check if installation exists
    check_installation

    # Interactive confirmation
    confirm_uninstall

    # Create backup
    backup_before_uninstall

    # Remove components
    remove_commands
    remove_settings
    remove_project_metadata
    cleanup_dependencies

    # Show summary
    show_uninstall_summary
}

# Parse command line arguments
FORCE=false
SKIP_BACKUP=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --force|-f)
            FORCE=true
            shift
            ;;
        --skip-backup)
            SKIP_BACKUP=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo
            echo "Options:"
            echo "  --force, -f        Skip confirmation prompts"
            echo "  --skip-backup      Skip creating backup before uninstallation"
            echo "  --help, -h         Show this help message"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Override backup behavior if requested
if [ "$SKIP_BACKUP" = true ]; then
    backup_before_uninstall() {
        print_warning "Skipping backup creation as requested"
    }
fi

# Override confirmation behavior if forced
if [ "$FORCE" = true ]; then
    confirm_uninstall() {
        print_warning "Force mode enabled - skipping confirmation"
    }
    remove_settings() {
        if [ -f "$CLAUDE_DIR/settings.local.json" ]; then
            rm "$CLAUDE_DIR/settings.local.json"
            print_success "Removed settings file (force mode)"
        fi
    }
fi

# Check if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi