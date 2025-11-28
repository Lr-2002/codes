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
├── .claude/                   # Claude Code settings
│   └── settings.local.json    # Permissions and configuration
├── install.sh                 # Installation script
├── update.sh                  # Update script
├── uninstall.sh               # Uninstallation script
├── install_depency.sh         # Dependency installation (MCP servers)
├── CLAUDE.md                  # This file
└── Python_CLAUDES.md          # Python development guidelines
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
   cp .claude/settings.local.json ~/.claude/
   ```

3. **Install Dependencies:**
   ```bash
   bash install_depency.sh
   ```

## Available Commands

After installation, the following custom slash commands are available in Claude Code:

- **`/commit`** - Create conventional commits with emoji support
- **`/update_commands`** - Update command documentation

## Management Scripts

- **`install.sh`** - Install all components to user-level Claude Code
- **`update.sh`** - Update existing installation with latest changes
- **`uninstall.sh`** - Remove installed components safely with backup

## Configuration

### Settings File
The `settings.local.json` file includes:
- Permissions for allowed bash commands
- MCP server configurations
- User-specific preferences

### Dependencies
The `install_depency.sh` script installs:
- `uv` package manager
- `serena` MCP server for enhanced code analysis
- MCP server configurations

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

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add or modify commands
4. Test with installation scripts
5. Submit a pull request

## License

This project is designed to extend Claude Code functionality. Respect Claude Code's terms of service when creating custom commands and configurations.