# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains custom tools, commands, and configurations for Claude Code. It's designed to be easily installed at the user level to enhance Claude Code functionality with custom slash commands and settings.

## Repository Structure

```
codes/
├── commands/                   # Custom slash commands
│   ├── commit.md              # Conventional commit command with emoji
│   └── update_commands.md     # Documentation update command
├── config/                    # Configuration files
│   └── settings.local.json    # Claude Code settings and permissions
├── docs/                      # Documentation
│   ├── CLAUDE.md              # This file (main documentation)
│   └── Python_CLAUDES.md      # Python development guidelines
├── scripts/                   # Installation and management scripts
│   ├── install.sh             # Main installation script
│   ├── install_depency.sh     # Dependency installation (MCP servers)
│   ├── update.sh              # Update existing installation
│   └── uninstall.sh           # Remove installation
├── tools/                     # Tools and utilities
│   └── claude-code-notifier.sh # System notification script
├── install.sh                 # Entry point installation script
├── update.sh                  # Entry point update script
└── uninstall.sh               # Entry point uninstall script
```

## Installation

### Quick Install

```bash
# Clone or download this repository
git clone <repository-url> codes
cd codes

# Install to user-level Claude Code settings
bash install.sh
```

### Manual Install

1. **Copy Commands:**
   ```bash
   mkdir -p ~/.claude/commands
   cp commands/*.md ~/.claude/commands/
   ```

2. **Copy Settings:**
   ```bash
   mkdir -p ~/.claude
   cp config/settings.local.json ~/.claude/
   ```

3. **Copy Notifier:**
   ```bash
   cp tools/claude-code-notifier.sh ~/.claude/
   chmod +x ~/.claude/claude-code-notifier.sh
   ```

4. **Install Dependencies:**
   ```bash
   bash scripts/install_depency.sh
   ```

## Available Commands

After installation, the following custom slash commands are available in Claude Code:

- **`/commit`** - Create conventional commits with emoji support
- **`/update_commands`** - Update command documentation

## System Notifications

The package includes a cross-platform system notifier that provides visual and audio alerts for Claude Code events:

### Supported Events
- **SessionStart** 🚀 - When Claude Code starts a new session
- **SessionEnd** ✅ - When Claude Code completes a session
- **Stop** 🏁 - When Claude Code finishes a response
- **Notification** - Custom notifications from Claude Code

### Platform Support
- **macOS**: Uses `terminal-notifier` with sound alerts
- **Linux**: Uses `notify-send` with visual notifications
- **Windows**: Uses PowerShell toast notifications

### Dependencies (Auto-installed)
- `jq` - JSON processing for all platforms
- `terminal-notifier` - macOS notifications (via Homebrew)
- `libnotify-bin` - Linux notifications (via apt/yum)

## Management Scripts

### Entry Point Scripts (Root Directory)
- **`install.sh`** - Entry point for installation (calls scripts/install.sh)
- **`update.sh`** - Entry point for updates (calls scripts/update.sh)
- **`uninstall.sh`** - Entry point for uninstallation (calls scripts/uninstall.sh)

### Core Scripts (scripts/ Directory)
- **`scripts/install.sh`** - Main installation script with all logic
- **`scripts/update.sh`** - Update existing installation with latest changes
- **`scripts/uninstall.sh`** - Remove installed components safely with backup
- **`scripts/install_depency.sh`** - Install MCP servers and dependencies

## Configuration

### Settings File
The `settings.local.json` file includes:
- Permissions for allowed bash commands (cmake, make, gcc, g++, etc.)
- MCP server configurations
- User-specific preferences
- System notification hooks for Claude Code events

### Dependencies
The `install_depency.sh` script installs:
- `uv` package manager
- `serena` MCP server for enhanced code analysis
- MCP server configurations

The `install.sh` script additionally installs:
- System notifier script and platform dependencies
- `jq` for JSON processing
- `terminal-notifier` on macOS
- `libnotify-bin` on Linux

## Development

### Adding New Commands

1. Create new markdown file in `commands/` directory
2. Follow the existing command format
3. Update `settings.local.json` if new permissions are needed
4. Test with `bash install.sh`

### Updating Commands

1. Modify command files in `commands/` directory
2. Run `bash update.sh` to apply changes
3. Test functionality in Claude Code

## Features

- **Safe Installation**: Automatic backup of existing settings
- **Easy Updates**: Incremental updates without data loss
- **Complete Uninstall**: Full removal with rollback capability
- **Cross-platform**: Works on macOS, Linux, and Windows (WSL)

## Requirements

- Claude Code (claude.ai/code)
- Bash shell
- Git (for version control commands)
- Python and uv (for MCP servers)
- Homebrew (recommended for macOS dependency installation)
- jq (auto-installed for notification processing)

### Optional for Notifications
- `terminal-notifier` (macOS - auto-installed via Homebrew)
- `libnotify-bin` (Linux - auto-installed via apt/yum)
- PowerShell with Windows UI notifications (Windows - built-in)

## Troubleshooting

### Installation Issues
- Ensure Claude Code is properly installed
- Check permissions on `~/.claude/` directory
- Run scripts with `bash` not `sh`

### Command Not Working
- Restart Claude Code after installation
- Verify commands exist in `~/.claude/commands/`
- Check settings file permissions

### Update Problems
- Check for backup in `~/.claude/backup_*` directories
- Manually restore from backup if needed
- Re-run install script as last resort

### Notification Issues
- **macOS**: Ensure `terminal-notifier` is installed (`brew install terminal-notifier`)
- **Linux**: Ensure `libnotify-bin` is installed (`sudo apt install libnotify-bin`)
- **All platforms**: Ensure `jq` is installed and the script is executable
- Check system notification settings are enabled
- Verify hooks configuration in `settings.local.json`
- Test manually: `echo '{"hook_event_name":"Notification","message":"Test"}' | ~/.claude/claude-code-notifier.sh`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add or modify commands
4. Test with installation scripts
5. Submit a pull request

## License

This project is designed to extend Claude Code functionality. Respect Claude Code's terms of service when creating custom commands and configurations.