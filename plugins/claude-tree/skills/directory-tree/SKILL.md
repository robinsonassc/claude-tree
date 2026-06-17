---
name: directory-tree
description: Use when the user wants to visualize, document, or save a directory or folder structure — generating a file tree, project layout map, folder index, or directory diagram, optionally written to a text, markdown, or Word (.docx) file.
---

# Directory Tree

## Overview
Generates a visual directory tree (box-drawing connectors `├──`, `└──`, `│`) for any folder, and can save it to a text, markdown, or Word `.docx` file. Useful for documenting project structure, sharing a folder layout with a team, or maintaining a folder index.

## When to Use
- "Show me the structure of this folder / project"
- "Save a file tree / directory map to a document"
- "Make a folder index I can share"
- "What does this directory look like, dirs only / N levels deep"

## Quick Reference
Run the bundled script (`${CLAUDE_PLUGIN_ROOT}/scripts/dirtree.py`):

| Goal | Command |
|------|---------|
| Print tree of a folder | `python dirtree.py /path` |
| Save plain text | `python dirtree.py /path -o tree.txt` |
| Markdown (fenced) | `python dirtree.py /path -f md -o STRUCTURE.md` |
| Word document | `python dirtree.py /path -f docx -o Index.docx` |
| Directories only | `python dirtree.py /path -d` |
| Limit depth | `python dirtree.py /path --depth 2` |
| Extra ignores | `python dirtree.py /path --ignore "*.log,tmp"` |

- Default ignores: `.git`, `node_modules`, `__pycache__`, `.venv`, `dist`, `build`, `.DS_Store`, `desktop.ini`, `Thumbs.db`, lock files, `*.pyc`. Disable with `--no-default-ignores`.
- `docx` format requires `python-docx` (`pip install python-docx`) and a `-o` path.
- Output ends with a `N directories, M files` summary (suppress with `--no-counts`).

## Staying Current (optional)
The script is a one-shot generator — re-run it to refresh. To keep an index updated automatically **without** running Claude, schedule it with the OS: on Windows use the bundled `scripts/setup-windows-task.ps1`; on macOS/Linux use `cron`. See the README.

## Common Mistakes
- `-f docx` without `-o` → errors; docx must be written to a file, not stdout.
- Box characters look garbled in a non-UTF8 terminal — write to a file (`-o`) or set `PYTHONUTF8=1`; file output is always UTF-8.
