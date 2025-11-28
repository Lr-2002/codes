#!/bin/bash

# Claude Code Custom Tools - Main Uninstallation Script
# This is the main entry point for uninstalling the Claude Code custom tools package

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Main uninstallation
main() {
    print_info "🗑️  Uninstalling Claude Code Custom Tools..."

    # Check if uninstall script exists
    if [ -f "$SCRIPT_DIR/scripts/uninstall.sh" ]; then
        # Make script executable and run it
        chmod +x "$SCRIPT_DIR/scripts/uninstall.sh"
        exec "$SCRIPT_DIR/scripts/uninstall.sh" "$@"
    else
        print_error "Uninstall script not found at scripts/uninstall.sh"
        exit 1
    fi
}

# Check if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi