# AI-CLI Logger

Small exporter for saving readable Markdown logs from AI CLI tools.

The installer adds `ai-session-export` to `~/.local/bin` and appends zsh wrapper
functions for supported tools when they are missing. The wrappers run the real
CLI and then export the latest native structured session log.

## Supported tools

- Codex
- Gemini
- Claude

## Default output

By default, exported logs are written to:

```text
~/terminal-logs/ai-cli
```

Logs are sorted by CLI tool:

```text
~/terminal-logs/ai-cli/Codex
~/terminal-logs/ai-cli/Gemini
~/terminal-logs/ai-cli/Claude
```

Each export writes a Markdown file and, when possible, a raw copy of the source
JSONL log.

## Install

```sh
./install-ai-logging.sh
source ~/.zshrc
```

Open a new terminal after installation if the shell functions are not available
in the current session.
