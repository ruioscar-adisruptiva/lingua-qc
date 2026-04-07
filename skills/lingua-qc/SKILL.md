---
name: lingua-qc
description: Revisar e corrigir qualidade linguística em PT-BR, Espanhol, Inglês e Italiano — acentuação, concordância, gramática, encoding HTML. Disparar quando o usuário disser "revisa", "corrige", "checa acentos", "revisar idioma", "check language", "Portuguese", "Spanish", "Italian", "encoding", "charset", "delivery-grade", "lingua", "quality check", "proofreading", "grammar check", ou quando escrever arquivos HTML/delivery-grade.
version: 1.0.0
---

# Lingua-QC — Multilingual Quality Control

## Core Concept: Two File Grades

Every file produced by an LLM falls into one of two categories:

**Delivery-grade** — files that reach human eyes: HTML pages, PDF source documents, DOCX, PPTX, XLSX, email templates, client presentations, public README files. These have **ZERO tolerance** for grammar, accentuation, or encoding errors. They must be publication-ready.

**LLM-grade** — files consumed only by other LLMs: CLAUDE.md, agent definitions, rule files, config files, internal notes, skill definitions. These must have correct accentuation but formatting is flexible — clarity for machine consumption matters more than typographic perfection.

The distinction matters because the cost of an accent error in a client presentation is orders of magnitude higher than in an internal config file.

## Quick File Classification

| Grade | Extensions/Patterns |
|-------|-------------------|
| **Delivery** | `.html`, `.htm`, `.css` (content/comments), `.jsx`/`.tsx` (UI strings), email templates, public `README.md` |
| **LLM** | `CLAUDE.md`, `agents/*.md`, `rules/*.md`, `skills/*/SKILL.md`, `.json`, `.yaml`, session logs |
| **Default** | When ambiguous → treat as Delivery (err on safety) |

Full classification map: `references/file-classification.md`

## Languages Covered

### Português Brasileiro (PT-BR)
Critical rules — proparoxítonas TODAS acentuadas:
análise, específico, diagnóstico, código, método, único, página, número, técnico, público

Til NUNCA omitir: informação, função, ação, não, então, solução, criação, condição
Cedilha NUNCA omitir: ação, função, preço, espaço, começo
Crase: "à escola", "às vezes" — nunca antes de verbo ou masculino
Complete rules: `references/pt-br.md`

### Español (ES)
Critical rules — esdrújulas TODAS acentuadas:
análisis, específico, diagnóstico, método, técnico, código, público, número, último, próximo

Tilde diacrítica: él/el, tú/tu, mí/mi, sí/si, más/mas, qué/que, cómo/como
ñ NUNCA omitir: año, niño, señor, español, montaña, mañana
¿¡ SIEMPRE abrir signos
Complete rules: `references/es.md`

### English (EN)
Critical rules — homophones:
its/it's, their/there/they're, your/you're, affect/effect, then/than, lose/loose

Punctuation: Oxford comma (consistent), em dash — (not --)
Complete rules: `references/en.md`

### Italiano (IT)
Critical rules — accents:
È (MAI "E'" con apostrofo), perché (MAI "perchè"), un po' (MAI "un pò"), qual è (MAI "qual'è")

Parole tronche: città, qualità, università, libertà, già, più, può, però, così, né
Complete rules: `references/it.md`

## HTML Encoding Protocol

Every HTML file MUST have:
1. `<!DOCTYPE html>`
2. `<meta charset="UTF-8">` as first tag inside `<head>`
3. `lang="pt-BR"` (or `es`, `en`, `it`) on the `<html>` tag
4. Native UTF-8 characters — NEVER HTML entities when charset is UTF-8 (use á, not `&aacute;`)
5. `lang=""` attributes on mixed-language internal elements

Full encoding guide: `references/html-encoding.md`

## Review Protocol

1. **Classify** — determine if file is Delivery-grade or LLM-grade
2. **Detect language** — check `lang` attribute, content analysis, or file context
3. **Check encoding** — for HTML files, verify charset, lang, DOCTYPE
4. **Scan content** — apply the specific language rules from references
5. **Correct** — fix errors using Edit tool
6. **Report** — structured output with correction count and details

## Golden Rules

1. NEVER modify code blocks, YAML frontmatter, URLs, variable names, technical terms
2. NEVER modify content inside ``` fenced code blocks
3. When a word is ambiguous (verb vs noun: "analise" can be subjunctive), use sentence context
4. "publico" can be verb (eu publico) — verify context before adding accent
5. In mixed-language files: apply each language's rules to its own sections
6. For proper nouns: only fix obvious accent errors (Jose → José, Jimenez → Jiménez)
7. When in doubt about an accent: ADD IT (omission is worse than excess in PT/ES/IT)
8. Delivery-grade files get ZERO tolerance; LLM-grade files get correct-but-flexible treatment

## Reference Loading Guide

Load references based on the task at hand — do NOT load all references at once:

- Reviewing Portuguese content → load `references/pt-br.md`
- Reviewing Spanish content → load `references/es.md`
- Reviewing English content → load `references/en.md`
- Reviewing Italian content → load `references/it.md`
- Reviewing HTML files → load `references/html-encoding.md`
- Classifying files → load `references/file-classification.md`

For a Portuguese HTML file: load `pt-br.md` + `html-encoding.md` (2 files).
For a multi-language directory: load all relevant language references.
