# Changelog

## Unreleased

- Add AbacusAI wrapper function to installer.
- Add AbacusAI support to `ai-session-export` using `~/.abacusai/history.jsonl`.
- Export AbacusAI logs into `~/terminal-logs/ai-cli/AbacusAI`.

## 0.2.0 - 2026-05-14

- Sort exported logs by AI CLI tool.
- Write Codex, Gemini, and Claude logs into separate folders under `~/terminal-logs/ai-cli`.

## 0.1.0 - 2026-05-14

- Import current AI CLI logging installer and exporter.
- Export readable Markdown logs from Codex, Gemini, and Claude native session logs.
- Write exported logs to `~/terminal-logs/ai-cli` by default.
