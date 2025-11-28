# AWS MCP Server Development Guide

## Build & Test Commands

### Using conda for venv create  (recommended)

- create venv : `conda create -n openai python=3.10`
- list venv: `conda env list`

### Using pip

use tsinghua source as our pypi source : `-i https://pypi.tuna.tsinghua.edu.cn/simple`

- Install dependencies: `pip install -e .`
- Install some dep: `pip install`
- Install dev dependencies: `pip install -e ".[dev]"`

### Testing and linting

- Run tests: `pytest`
- Run linter: `ruff check src/ tests/`
- Format code: `ruff format src/ tests/`
- Download Linter: `pip install ruff`

## Technical Stack

- **Python version**: Python 3.10+
- **Environment**: Use virtual environment `conda` for dependency isolation
- **Package management**: Use `pip` for stable dependency management
- **Linting**: `ruff` for style and error checking
- **Type checking**: Use VS Code with Pylance for static type checking
- **Project layout**: Organize code with `src/` layout

## Code Style Guidelines

- **Formatting**: Black-compatible formatting via `ruff format`
- **Imports**: Sort imports with `ruff` (stdlib, third-party, local)
- **Type hints**: Use native Python type hints (e.g., `list[str]` not `List[str]`)
- **Documentation**: Google-style docstrings for all modules, classes, functions
- **Naming**: snake_case for variables/functions, PascalCase for classes
- **Function length**: Keep functions short (< 30 lines) and single-purpose
- **PEP 8**: Follow PEP 8 style guide (enforced via `ruff`)

## Python Best Practices

- **File handling**: Prefer `pathlib.Path` over `os.path`
- **Debugging**: Use `logging` module instead of `print`
- **Error handling**: Use specific exceptions with context messages and proper logging
- **Data structures**: Use list/dict comprehensions for concise, readable code
- **Function arguments**: Avoid mutable default arguments
- **Data containers**: Leverage `dataclasses` to reduce boilerplate
- **Configuration**: Use environment variables (via `python-dotenv`) for configuration
- **Security**: Never store/log credentials(openai token, github token )

## Development Patterns & Best Practices

- **Favor simplicity**: Choose the simplest solution that meets requirements
- **DRY principle**: Avoid code duplication; reuse existing functionality
- **Configuration management**: Use environment variables for different environments
- **Focused changes**: Only implement explicitly requested or fully understood changes
- **Preserve patterns**: Follow existing code patterns when fixing bugs
- **File size**: Keep files under 300 lines; refactor when exceeding this limit
- **Modular design**: Create reusable, modular components
- **Logging**: Implement appropriate logging levels (debug, info, error)
- **Error handling**: Default to be Debugging mode without try-except block which will remove traceback, once I change the mode of the system in CLAUDE.md to `RELEASE` then try to fix the try-except block
- **Security best practices**: Follow input validation and data protection practices
- **Performance**: Optimize critical code sections when necessary
- **Dependency management**: Add libraries only when essential
  - When adding/updating dependencies, update `requirements` first

## Development Workflow

- **Version control**: Commit frequently with clear messages
- **Versioning**: Use Git tags for versioning (e.g., `git tag -a 1.2.3 -m "Release 1.2.3"`)
  - For releases, create and push a tag
- **Impact assessment**: Evaluate how changes affect other codebase areas
- **Documentation**: Keep documentation up-to-date for complex logic and features

## Important Notes

- IF you are not sure about my purpose, ask me before you execute
