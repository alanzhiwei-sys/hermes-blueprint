# Development Environment — Artemis Coder

## Overview

This document defines the canonical development toolchain for Artemis projects. Every developer on the team must have this environment configured and verified before their first commit. Consistency across machines eliminates "works on my machine" bugs and cuts onboarding time from days to hours.

## Toolchain

### Python

- **Version:** Python 3.11+ (managed via `pyenv` for local development; Docker images pin exact patch versions).
- **Package management:** `uv` for dependency resolution and virtual environment management. Never use raw `pip install` outside a managed venv. PEP 668 is enforced on the host — `uv` is the approved path.
- **Linting & formatting:** `ruff` for both linting and formatting (replaces flake8, isort, black). `mypy` for static type checking in strict mode on all new code.
- **Testing:** `pytest` with `pytest-cov` (minimum 80% line coverage on new modules). `pytest-xdist` for parallel test runs in CI.

```bash
# Quick-start a new Python project
uv venv
source .venv/bin/activate
uv pip install ruff mypy pytest pytest-cov
```

### Node.js

- **Version:** Node 20 LTS (managed via `fnm` or `nvm`).
- **Package manager:** `pnpm` — faster installs, stricter dependency resolution, and disk-efficient storage.
- **Linting & formatting:** `biome` for both linting and formatting (single tool, replaces ESLint + Prettier). Configure via `biome.json` at project root.
- **Testing:** `vitest` for unit and integration tests. `playwright` for end-to-end browser tests.
- **TypeScript:** Strict mode (`"strict": true` in tsconfig). All new code is TypeScript — JavaScript is legacy-only.

```bash
# Quick-start a new Node project
fnm use 20
pnpm init
pnpm add -D @biomejs/biome vitest typescript
```

### Git

- **Strategy:** Trunk-based development. Feature branches live a maximum of 2 days. Rebase, don't merge.
- **Commit messages:** Conventional Commits format: `type(scope): description`. Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`. Example: `feat(auth): add magic-link email authentication`.
- **Hooks:** `pre-commit` runs ruff/biome + unit tests. `commit-msg` validates Conventional Commits format. Managed via `lefthook` (faster than husky, no Node dependency for Python repos).
- **Global gitignore:** Maintain a `~/.gitignore_global` with OS files (`.DS_Store`, `Thumbs.db`), editor temp files (`*.swp`, `*~`), and Python caches (`__pycache__/`, `*.pyc`).

### Docker

- **Local development:** Use `docker compose` for services (PostgreSQL, Redis, MinIO). Never install databases directly on the host.
- **Images:** Multi-stage builds only. Production images must be distroless or slim variants. No devDependencies in production layers.
- **Compose profiles:** Use profiles (`dev`, `test`, `prod`) to control which services start. `docker compose --profile dev up` for local work.

## IDE Configuration

**Primary IDE:** VS Code (standardised across the team). Alternative: Neovim (supported, but team config files target VS Code).

**Required extensions** (committed as `.vscode/extensions.json` in every repo):
- Python: `ms-python.python`, `charliermarsh.ruff`, `ms-python.mypy-type-checker`
- Node/TS: `biomejs.biome`, `vitest.explorer`
- General: `eamodio.gitlens`, `streetsidesoftware.code-spell-checker`, `editorconfig.editorconfig`

**Workspace settings** (`.vscode/settings.json` — committed, not in gitignore):
```json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": "explicit",
    "source.organizeImports": "explicit"
  },
  "editor.rulers": [100],
  "files.trimTrailingWhitespace": true,
  "files.insertFinalNewline": true,
  "[python]": { "editor.defaultFormatter": "charliermarsh.ruff" }
}
```

## Dotfiles

Team dotfiles live in a shared repository (`artemis-coder/dotfiles`) and are installed via a `bootstrap.sh` script. Every new machine runs this script once.

**What the dotfiles cover:**
- `.bashrc` / `.zshrc`: aliases (`gap="git add -p"`, `gcm="git commit -m"`, `docker-prune="docker system prune -af"`), PATH additions, `uv` shell completions
- `.gitconfig`: name, email, default branch (`main`), rebase preference, diff/merge tool
- `.editorconfig`: charset, indentation, and newline rules applied across all editors
- `.lefthook.yml`: pre-commit and commit-msg hooks
- `.python-version`: pinned to the team's current Python version for pyenv

**Installation:**
```bash
git clone [EMAIL_REDACTED]:artemis-coder/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./bootstrap.sh
```

## Environment Verification

Run the self-check script before your first commit on any machine:

```bash
artemis-check
```

This script validates: Python version, Node version, uv/pnpm availability, Docker daemon running, git config present, lefthook installed, and IDE extensions match the workspace recommendations. A failing check blocks CI — fix your environment first.

## Revision History
- 2026-06-10 — Initial publication
