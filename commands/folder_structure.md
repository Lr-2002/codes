# Claude Command: Folder Structure Guide

This command displays the standard project structure guidelines for software development in this organization.

## Usage

To show the folder structure guide:

```
/folder_structure
```

## What This Command Does

1. **Displays the complete folder structure guide** from the organization's standards document, use `tree` command to load and read  the structure and give comprehensive notation 
2. **distinguish the strucutre of the code in this folder**: Python or C++ or otherthings. maybe there are a lot, distinguish between them 
3. **Shows directory layouts** for different project types (Python, C++, Full-Stack, etc.)
4. **Printout the strucutre with notation**

## Supported Project Types

### 🧱 General Project Structure
- **Standard layout** for most software projects
- **Core directories**: `src/`, `docs/`, `scripts/`, `config/`, `tests/`
- **Clear separation** of code, documentation, and configuration

### 🐍 Python Projects
- **Package structure** with proper `__init__.py` files
- **Module organization**: `core/`, `control/`, `perception/`, `hardware/`
- **Separated concerns**: production code vs experiments

### 🦾 C++/Robotics/ROS Projects
- **Header/implementation separation** (`include/` vs `src/`)
- **ROS integration**: `msg/`, `srv/`, `launch/`, `urdf/`
- **Modular package design** principles

### 🌐 Full-Stack/Web Projects
- **Backend separation** (API, models, services)
- **Frontend organization** (components, pages, hooks)
- **Clear boundaries** between frontend and backend

## Key Principles

- **Code lives in `src/`** - primary implementation goes here
- **Configuration in `config/`** - all YAML/JSON/TOML files
- **Documentation in `docs/`** - architecture, protocols, setup guides
- **Scripts in `scripts/`** - utilities, deployment, and automation
- **Tests mirror src structure** - maintain parallel organization
- **No generated files in Git** - build/, output/, data/, etc.

## Naming Conventions

### Folders
- **Python**: `snake_case`
- **C++**: `PascalCase` for class names
- **No Chinese folder names**
- **Keep names short and meaningful**

### Files
- **Python**: One class per file, proper `__init__.py`
- **C++**: Headers in `include/`, implementations in `src/`
- **Config**: YAML preferred over hardcoded values

## What NOT to Commit

```
build/          # Build outputs
output/         # Logs and temporary results
data/           # Large datasets
*.log           # Log files
*.pt *.onnx     # Model weights
__pycache__/    # Python cache
.vscode/ .idea/ # Editor files
.DS_Store       # macOS files
```

## Benefits of Proper Structure

1. **Better maintainability** - clear organization makes code easier to navigate
2. **Team collaboration** - consistent structure across projects
3. **Tooling integration** - standard layouts work better with IDEs and CI/CD
4. **Scalability** - easy to add new features without cluttering the root
5. **Professional standards** - follows industry best practices
