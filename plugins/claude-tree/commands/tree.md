---
description: Generate a directory tree for a path, optionally saved to a file
argument-hint: "[path] [-f txt|md|docx] [-o output] [-d] [--depth N]"
---

Generate a directory tree using the bundled generator. Pass the user's arguments straight through:

```
python "${CLAUDE_PLUGIN_ROOT}/scripts/dirtree.py" $ARGUMENTS
```

Guidance:
- If the user gave no path, default to the current directory (`.`).
- On Windows, if `python` is not found, try `py -3`. On macOS/Linux use `python3`.
- Common flags: `-o FILE` to save, `-f md|docx` for markdown or Word output (docx requires `python-docx` and a `-o` path), `-d` for directories only, `--depth N` to limit levels, `--ignore "*.log,tmp"` for extra excludes.
- The generator already skips `.git`, `node_modules`, `__pycache__`, `dist`, `.DS_Store`, `desktop.ini`, lock files, etc. by default.

After running, show the user the tree (or confirm the file path it was written to and the directory/file counts).
