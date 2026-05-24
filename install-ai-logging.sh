#!/usr/bin/env bash
set -euo pipefail

NEW_HOME="${HOME}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${NEW_HOME}/.local/bin"
LOG_DIR="${NEW_HOME}/terminal-logs/ai-cli"
ZSHRC="${NEW_HOME}/.zshrc"

echo "Porting AI CLI Logging Feature..."

# 1. Ensure directories exist
mkdir -p "${BIN_DIR}"
mkdir -p "${LOG_DIR}"

# 2. Copy the export script
cp "${SCRIPT_DIR}/bin/ai-session-export" "${BIN_DIR}/"
chmod +x "${BIN_DIR}/ai-session-export"
echo "  [+] Copied ai-session-export to ${BIN_DIR}"

# 3. Add Zsh functions to .zshrc if not present
if ! grep -q "_ai_cli_logged_run" "${ZSHRC}"; then
  echo "  [+] Adding wrapper functions to ${ZSHRC}"
  cat << 'EOF' >> "${ZSHRC}"

# --- AI CLI Auto-Logging Feature ---
# Auto-export long AI CLI sessions from each tool's native structured logs.
_ai_cli_logged_run() {
  emulate -L zsh
  setopt localoptions no_aliases

  local tool="$1"
  local executable="$2"
  shift 2

  if [[ ! -x "$executable" ]]; then
    print -u2 "Cannot find executable for $tool: $executable"
    return 127
  fi

  local started_epoch exit_code exported_log transcript_file
  started_epoch="$(date +%s)"

  if [[ "$tool" == "abacusai" ]]; then
    transcript_file="${TMPDIR:-/tmp}/abacusai-session-${started_epoch}-$$.log"
    script -q "$transcript_file" "$executable" "$@"
    exit_code=$?
    exported_log="$(ai-session-export "$tool" --file "$transcript_file" 2>/dev/null)"
    rm -f "$transcript_file"
  else
    "$executable" "$@"
    exit_code=$?
    exported_log="$(ai-session-export "$tool" --latest --after "$started_epoch" 2>/dev/null)"
  fi

  if [[ -n "$exported_log" ]]; then
    print -r -- "Saved ${tool} session log: ${exported_log}"
  else
    print -r -- "No structured ${tool} session log found to export."
  fi

  return "$exit_code"
}

codex() {
  _ai_cli_logged_run codex /opt/homebrew/bin/codex "$@"
}

gemini() {
  _ai_cli_logged_run gemini /opt/homebrew/bin/gemini "$@"
}

claude() {
  _ai_cli_logged_run claude "$HOME/.local/bin/claude" "$@"
}

abacusai() {
  _ai_cli_logged_run abacusai "$HOME/.abacusai/bin/abacusai" "$@"
}
# ------------------------------------
EOF
else
  echo "  [!] Wrapper functions already exist in ${ZSHRC}, skipping."
fi

echo ""
echo "Done! The 'ai-cli logging' feature is now ported."
echo "Changes will take effect in new terminal windows, or run: source ~/.zshrc"
