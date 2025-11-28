# Claude Command: Python Guidelines

This command loads Python-specific development guidelines and best practices for Claude to reference when working with Python code.

## Usage

```
/python-guidelines
```

## What This Command Does

When you use this command, Claude will:

1. **Read the Python_CLAUDE.md file** - Contains comprehensive Python development guidelines
2. **Load Python-specific context** including:
   - Environment setup instructions (conda, pip, virtual environments)
   - Code style guidelines (ruff, type hints, documentation)
   - Testing and linting procedures (pytest, ruff check/format)
   - Python best practices (pathlib, logging, error handling)
   - Development patterns and workflows
3. **Apply guidelines automatically** to all subsequent Python-related tasks in this session

## Available Guidelines

The Python_CLAUDE.md file includes:

### 🛠️ **Development Environment**
- conda environment management
- pip package installation with Tsinghua source
- Virtual environment best practices

### 📝 **Code Style & Quality**
- ruff for linting and formatting
- Native Python type hints
- Google-style docstrings
- PEP 8 compliance

### 🔧 **Python Best Practices**
- pathlib.Path over os.path
- logging instead of print
- Specific exceptions with context
- dataclasses for reduced boilerplate
- Environment variables for configuration

### 🧪 **Testing & Development**
- pytest for testing
- Development workflow patterns
- Version control practices

## Multi-Language Support

This system is designed to work with multiple languages:

- **Current**: Python guidelines available via `/python-guidelines`
- **Future**: Can add `Cpp_CLAUDE.md` with `/cpp-guidelines` command
- **Extensible**: Easy to add new languages following the same pattern

## Automatic Context Loading

The command ensures Claude automatically references:
- Proper import sorting (stdlib, third-party, local)
- Function length guidelines (< 30 lines)
- Security best practices (no credential logging)
- Performance optimization guidelines
- Dependency management principles

## Session Persistence

Once loaded, these guidelines remain active throughout your current Claude Code session, ensuring consistent Python development practices across all tasks.

---

**To use**: Simply type `/python-guidelines` when starting Python development work.