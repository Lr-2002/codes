📁 Project Structure Guide (Standard for Claude Code)

This document defines the standard folder structure for all software projects in this organization.
Claude Code should follow this document when generating new files, organizing code, or refactoring repositories.

⸻

🧱 1. High-Level Project Layout

project/
├── docs/               # Documentation, design notes, architecture diagrams
├── src/                # Core source code (primary implementation)
├── include/            # Header files (C/C++ projects only)
├── scripts/            # Utility scripts (setup, deployment, calibration, training)
├── config/             # YAML/JSON/TOML configuration files
├── tests/              # Unit tests and integration tests
├── assets/             # Static assets (images, icons, models)
├── examples/           # Usage examples, demo scripts
├── tools/              # Small tools, data converters, analyzer utilities
├── third_party/        # External dependencies (vendored)
├── build/              # Build outputs (not committed)
├── output/             # Logs, checkpoints, temporary results (not committed)
├── .gitignore
├── README.md
└── LICENSE

Principles:
	•	Code lives in src/
	•	Config lives in config/
	•	Generated files never enter Git
	•	Documentation stays in docs/
	•	Scripts go to scripts/
	•	Tests must mirror src/ structure

⸻

🧩 2. Python Project Structure

project/
├── project_name/
│   ├── __init__.py
│   ├── core/               # Core logic
│   ├── control/            # Control algorithms (ADRC, FOC, MPC, etc.)
│   ├── perception/         # Vision modules, VLM, models
│   ├── hardware/           # CAN-FD, drivers, motor interfaces
│   ├── env/                # Simulation (MuJoCo, Isaac, Genesis)
│   ├── utils/              # Utility functions
│   ├── models/             # ML weights (ignored in Git)
│   └── config/             # YAML/JSON configs
├── scripts/
├── tests/
├── notebooks/
└── pyproject.toml / setup.py

Rules:
	•	Never mix experiments and production code
	•	Put experiments in notebooks/
	•	Python modules must have __init__.py
	•	Hardware interfacing code belongs in hardware/

⸻

🧱 3. C++ / Robotics / ROS Project Structure

project/
├── include/project_name/    # Public headers
├── src/                     # Implementations
├── msg/ srv/ action/        # ROS message definitions
├── launch/                  # ROS launch files
├── config/                  # Controller configs, URDF paths
├── urdf/                    # Robot models
├── scripts/                 # Python helpers
├── test/
└── CMakeLists.txt

Rules:
	•	No logic in headers (except templates)
	•	Packages must be modular
	•	All parameters belong in config/
	•	Robot model files stay inside urdf/

⸻

🌐 4. Full-Stack / Web Project Structure

Backend (Node, FastAPI, Flask, Django)

backend/
├── app/
│   ├── api/             # Routes / endpoints
│   ├── models/          # Database models
│   ├── services/        # Business logic
│   ├── core/            # Settings, auth, startup
│   ├── utils/
│   └── main.py
├── tests/
├── scripts/
└── requirements.txt / package.json

Frontend (React, Vue)

frontend/
├── src/
│   ├── components/
│   ├── pages/
│   ├── hooks/
│   ├── assets/
│   └── utils/
├── public/
└── package.json




⸻

🔧 5. Naming & Code Organization Conventions

Folders
	•	snake_case for Python
	•	PascalCase for C++ class names
	•	No Chinese folder names
	•	Keep folder names short and meaningful

Files
	•	Each module should contain __init__.py
	•	One class per file (Python)
	•	C++: header in include/, implementation in src/

Config
	•	Use YAML when possible
	•	Never hardcode magic numbers
	•	Store robot parameters in config/params.yaml

Docs
	•	All architecture diagrams → docs/architecture/
	•	Communication protocols → docs/protocols/
	•	Calibration and setup → docs/calibration/

⸻

🧪 6. Testing Requirements

tests/
└── module_name/
    ├── test_feature_a.py
    ├── test_feature_b.py
    └── ...

Rules:
	•	Test names must match module names
	•	Each PR must include tests for new features
	•	Tests must be runnable via:

pytest



⸻

🚫 7. What Should NOT Be Committed

Add this to .gitignore:

build/
output/
data/
*.log
*.pt
*.onnx
*.ckpt
__pycache__/
.vscode/
.idea/
.DS_Store


⸻

🎯 8. Summary for Claude Code

Claude Code must always:
	1.	Generate files in the correct directory based on this document
	2.	Avoid creating new root-level folders unless necessary
	3.	Follow naming conventions strictly
	4.	Place large logic in src/, not in scripts
	5.	Use docs/ for all architecture and explanation files
