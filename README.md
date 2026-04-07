# Lingua-QC — Multilingual Quality Control for Claude Code

Zero-tolerance grammar and encoding enforcement for **Portuguese Brazilian**, **Spanish**, **English**, and **Italian**.

## The Innovation: LLM-grade vs Delivery-grade

Not all files are created equal. Lingua-QC classifies every file into two grades:

- **Delivery-grade** — files that reach human eyes (HTML, PDF source, DOCX, presentations, emails, public README). These get **zero tolerance** for accent, grammar, or encoding errors.
- **LLM-grade** — files consumed by LLMs (CLAUDE.md, agent definitions, rules, configs). These must be correct but formatting is flexible.

## Languages

| Language | Key checks |
|----------|-----------|
| **PT-BR** | Proparoxítonas, til (-ção/-ão), cedilha, crase, concordância |
| **Español** | Esdrújulas, tilde diacrítica, ñ, ¿¡, diéresis (ü) |
| **English** | its/it's, their/there, affect/effect, Oxford comma |
| **Italiano** | È (not E'), perché (not perchè), un po' (not pò), qual è (not qual'è) |

## HTML Encoding

Lingua-QC enforces:
- `<meta charset="UTF-8">` as first element in `<head>`
- `lang=""` attribute on `<html>` tag
- Native UTF-8 characters instead of HTML entities (á, not `&aacute;`)

## Installation

```bash
# Clone the repository
git clone https://github.com/ruiadisruptiva/lingua-qc.git ~/.claude/plugins/cache/local/lingua-qc/local

# Enable in Claude Code settings
claude settings set enabledPlugins.lingua-qc@local true
```

Or install from marketplace:
```
/plugin install lingua-qc
```

## Usage

```
/lingua                     # Review files modified in last 30 minutes
/lingua path/to/file.md     # Review specific file
/lingua --all src/pages/    # Review all text files in directory
/lingua --html              # Focus on HTML encoding + content
/lingua --delivery          # Only review delivery-grade files
```

## Automatic Hooks

- **PostToolUse**: When you write/edit a delivery-grade file, Lingua-QC reminds Claude to check encoding and accentuation
- **Stop**: When delivery-grade files were modified during a session, suggests running `/lingua`

## Components

| Component | Description |
|-----------|------------|
| `/lingua` command | Main review command with file discovery and correction |
| `lingua-qc` skill | Core knowledge with progressive disclosure (6 reference files) |
| `lingua-reviewer` agent | Deep review agent for batch processing large directories |
| PostToolUse hook | Automatic reminder on delivery-grade file writes |
| Stop hook | End-of-session reminder for modified delivery-grade files |

## Requirements

- Claude Code 2.0+
- `jq` (for hooks) — pre-installed on most systems
- `bash` (for hooks)

## License

MIT
