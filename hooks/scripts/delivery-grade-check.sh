#!/usr/bin/env bash
# Lingua-QC: PostToolUse hook for delivery-grade file detection
# Fires after Write|Edit — checks if the file is delivery-grade
# and injects a systemMessage reminder about encoding and quality.
# Always exits 0 (never blocks operations).

set -euo pipefail

# Read tool input from stdin
INPUT=$(cat)

# Extract file path from tool input
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.filePath // empty' 2>/dev/null)

# If no file path found, exit silently
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Extract file extension
EXT="${FILE_PATH##*.}"
EXT_LOWER=$(echo "$EXT" | tr '[:upper:]' '[:lower:]')

# Check if file is delivery-grade by extension
case "$EXT_LOWER" in
  html|htm|css|jsx|tsx|vue|svelte|mjml|ejs|hbs|pug|njk)
    DELIVERY=true
    ;;
  *)
    DELIVERY=false
    ;;
esac

# Check if file is in a delivery-grade directory
if [ "$DELIVERY" = false ]; then
  case "$FILE_PATH" in
    */email/*|*/emails/*|*/templates/*|*/newsletter/*|*/marketing/*|*/public/*|*/static/*|*/dist/*|*/build/*|*/out/*)
      DELIVERY=true
      ;;
  esac
fi

# Check if it's a README.md (potentially delivery-grade)
BASENAME=$(basename "$FILE_PATH")
if [ "$BASENAME" = "README.md" ] || [ "$BASENAME" = "readme.md" ]; then
  # Check if in a git repo with remotes (public)
  DIR=$(dirname "$FILE_PATH")
  if [ -d "$DIR/.git" ] || git -C "$DIR" rev-parse --git-dir >/dev/null 2>&1; then
    if git -C "$DIR" remote -v 2>/dev/null | grep -q .; then
      DELIVERY=true
    fi
  fi
fi

# If delivery-grade, emit systemMessage
if [ "$DELIVERY" = true ]; then
  cat <<'REMINDER'
{
  "systemMessage": "LINGUA-QC: A delivery-grade file was just written. Before completing this task, verify: (1) If HTML: charset=UTF-8 declared, lang attribute on <html>, no unnecessary HTML entities. (2) Accentuation and grammar are correct for the detected language (PT-BR/ES/EN/IT). (3) Apply zero-tolerance standard — this file reaches human eyes. Load the lingua-qc skill references if a thorough review is needed."
}
REMINDER
fi

exit 0
