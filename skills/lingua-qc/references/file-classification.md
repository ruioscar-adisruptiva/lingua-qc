# File Classification: LLM-grade vs Delivery-grade

## The Two Grades

### Delivery-grade (ZERO tolerance for errors)

Files that reach human eyes — clients, colleagues, the public. Every accent, every comma, every encoding declaration matters.

**By extension:**
- `.html`, `.htm` — web pages, landing pages, documentation sites
- `.css` — stylesheets (comments in natural language, `content:` property values)
- `.jsx`, `.tsx` — React/Next.js components (string literals, UI text, aria labels)
- `.vue` — Vue components (template text, comments)
- `.svelte` — Svelte components (template text)
- `.mjml` — email markup templates
- `.ejs`, `.hbs`, `.pug`, `.njk` — server-side templates

**By context:**
- `README.md` in public repositories (detected by `.git/config` containing a remote, or `.github/` directory)
- `CHANGELOG.md`, `CONTRIBUTING.md` in public repositories
- Files in directories named: `email/`, `emails/`, `templates/`, `newsletter/`, `marketing/`, `public/`, `static/`, `dist/`, `build/`, `out/`
- Any file explicitly marked as client-facing or for external delivery

**Source files for shareable formats:**
- Markdown that will be converted to PDF, DOCX, PPTX via pandoc/LibreOffice
- HTML that will be rendered to PDF via wkhtmltopdf/Puppeteer/Playwright

### LLM-grade (correct but flexible)

Files consumed by LLMs or developers as tooling. Accentuation must be correct, but formatting priorities are clarity and machine parseability.

**By filename:**
- `CLAUDE.md`, `AGENTS.md`, `GEMINI.md` — LLM instruction files
- `SKILL.md` — skill definitions
- `*.local.md` — local override files

**By directory:**
- Files in `agents/` directories — agent definitions
- Files in `rules/` directories — conditional rules
- Files in `skills/` directories — skill files and references
- Files in `hooks/` directories — hook configurations
- Files in `.claude/` directories — Claude Code configuration
- Files in `sessoes/`, `sessions/` — session logs

**By extension:**
- `.json`, `.yaml`, `.yml`, `.toml` — configuration files
- `.env`, `.env.example` — environment files

### Ambiguous files → Default to Delivery-grade

When classification is unclear, treat the file as Delivery-grade. The cost of over-checking is minimal; the cost of missing an error in a human-facing file is significant.

## Detection Heuristics

To classify a file automatically:

1. **Check extension** — `.html`/`.htm` → always Delivery
2. **Check parent directory** — `agents/` → LLM, `public/` → Delivery
3. **Check filename** — `CLAUDE.md` → LLM, `README.md` → check if public repo
4. **Check frontmatter** — files with `---\npaths:` or `---\ndescription:` in agent/rule format → LLM
5. **Check content** — HTML with `<!DOCTYPE` → Delivery
6. **Default** → Delivery-grade

## Implications by Grade

| Aspect | Delivery-grade | LLM-grade |
|--------|---------------|-----------|
| Accent errors | Fix ALL, zero tolerance | Fix ALL (still correct) |
| HTML encoding | Enforce charset, lang, DOCTYPE | Not applicable |
| HTML entities | Convert to native UTF-8 chars | Not applicable |
| Grammar | Full check | Basic check |
| Formatting | Publication-ready | Functional clarity |
| Review priority | HIGH — always review | NORMAL — review if time |
| Report severity | Errors are CRITICAL | Errors are WARNING |
