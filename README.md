# claude-tree

A Claude Code plugin that generates a visual **directory tree** for any folder and optionally saves it to a **text**, **markdown**, or **Word (`.docx`)** file. Handy for documenting project structure, sharing a folder layout with a team, or maintaining an auto-refreshed folder index.

```
Proving Grounds/
├── 00-Templates/
│   ├── Letterhead Assets/
│   │   ├── letterhead_image1.png
│   │   └── letterhead_image2.png
│   └── Sponsorship Letter.docx
├── 02-Partners/
│   ├── DASPA/
│   └── Ministry of Tourism/
└── 04-Budget/
    └── Proving Grounds Budget Tracker.xlsx

19 directories, 27 files
```

## Install

```
/plugin marketplace add robinsonassc/claude-tree
/plugin install claude-tree@claude-tree
```

Then restart Claude Code so the `/tree` command and `directory-tree` skill load.

## Usage

In Claude Code:

```
/tree                       # tree of the current directory
/tree G:\path\to\project    # tree of a specific folder
/tree . -d --depth 2        # directories only, 2 levels deep
/tree . -f md -o STRUCTURE.md
/tree . -f docx -o Index.docx
```

Or run the script directly:

```
python plugins/claude-tree/scripts/dirtree.py /path/to/dir -o tree.txt
```

### Options

| Flag | Meaning |
|------|---------|
| `-o, --output FILE` | Write to a file (otherwise prints to stdout) |
| `-f, --format txt\|md\|docx` | Output format (default `txt`; `docx` needs `python-docx` + `-o`) |
| `-d, --dir-only` | Show directories only |
| `--depth N` | Limit tree depth to N levels below the root |
| `--ignore "a,b,*.log"` | Extra names/globs to ignore |
| `--no-default-ignores` | Don't apply the built-in ignore list |
| `--no-counts` | Omit the trailing `N directories, M files` line |
| `--title "..."` | Override the document title |

Default ignores: `.git`, `.svn`, `.hg`, `node_modules`, `__pycache__`, `.venv`, `venv`, `.next`, `dist`, `build`, `.DS_Store`, `desktop.ini`, `Thumbs.db`, lock files (`~$*`), `*.pyc`.

## Requirements

- **Python 3.8+** (standard library only for `txt`/`md`).
- **`python-docx`** only if you use `-f docx`: `pip install python-docx`.
- Works on Windows, macOS, and Linux. File output is always UTF-8; for box characters in a Windows console set `PYTHONUTF8=1` or just write to a file.

## Keeping an index current automatically

The generator is a one-shot tool — re-run it to refresh. To keep a shared index up to date **without** opening Claude, let the OS run it on a schedule:

**Windows** (bundled helper — verifies the command, then registers a Scheduled Task):

```powershell
# Daily at 08:00, writes 00-Folder-Index.txt at the folder root
.\plugins\claude-tree\scripts\setup-windows-task.ps1 -Root "G:\My Drive\My Project"

# Word output, also refresh at logon
.\plugins\claude-tree\scripts\setup-windows-task.ps1 -Root "C:\Project" -Format docx -AtLogon
```

Remove it with `Unregister-ScheduledTask -TaskName 'Claude Tree - Folder Index' -Confirm:$false`.

**macOS / Linux** (cron — daily at 08:00):

```cron
0 8 * * * /usr/bin/python3 /path/to/dirtree.py "/path/to/project" -o "/path/to/project/00-Folder-Index.txt"
```

## License

MIT © Robinson & Associates
