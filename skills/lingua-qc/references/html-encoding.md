# HTML Encoding & Charset — Rules

## Mandatory HTML Structure

Every HTML file generated MUST begin with:

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <!-- other meta tags, title, etc. -->
</head>
```

### Rule 1: DOCTYPE
Always `<!DOCTYPE html>`. No legacy doctypes, no XHTML declarations.

### Rule 2: charset
`<meta charset="UTF-8">` MUST be the first element inside `<head>`, before any other `<meta>`, `<title>`, or `<link>` tags. This ensures the browser reads the encoding declaration before processing any content.

### Rule 3: lang attribute
The `<html>` tag MUST have a `lang` attribute:
- Portuguese Brazilian: `lang="pt-BR"`
- Spanish: `lang="es"`
- English: `lang="en"`
- Italian: `lang="it"`
- French: `lang="fr"`
- German: `lang="de"`

### Rule 4: Mixed-language content
For pages with content in multiple languages, use `lang` on internal elements:

```html
<html lang="pt-BR">
<body>
  <p>Este parágrafo está em português.</p>
  <blockquote lang="it">
    <p>Questa citazione è in italiano.</p>
  </blockquote>
  <p lang="es">Este párrafo está en español.</p>
</body>
</html>
```

## Native Characters vs HTML Entities

### When charset is UTF-8: USE NATIVE CHARACTERS

When `<meta charset="UTF-8">` is declared, ALWAYS use native Unicode characters instead of HTML entities:

| WRONG (entity) | CORRECT (native) |
|-----------------|-------------------|
| `&aacute;` | á |
| `&eacute;` | é |
| `&iacute;` | í |
| `&oacute;` | ó |
| `&uacute;` | ú |
| `&atilde;` | ã |
| `&otilde;` | õ |
| `&ccedil;` | ç |
| `&Aacute;` | Á |
| `&ntilde;` | ñ |
| `&Ntilde;` | Ñ |
| `&iquest;` | ¿ |
| `&iexcl;` | ¡ |
| `&egrave;` | è |
| `&Egrave;` | È |
| `&agrave;` | à |
| `&ecirc;` | ê |
| `&uuml;` | ü |
| `&ouml;` | ö |
| `&szlig;` | ß |
| `&rsquo;` | ' |
| `&lsquo;` | ' |
| `&rdquo;` | " |
| `&ldquo;` | " |
| `&mdash;` | — |
| `&ndash;` | – |
| `&hellip;` | … |

### Entities that ARE still valid with UTF-8

These entities should be kept because they represent special HTML characters:

| Entity | Character | Reason to keep |
|--------|-----------|----------------|
| `&amp;` | & | Prevents HTML parsing errors |
| `&lt;` | < | Prevents tag interpretation |
| `&gt;` | > | Prevents tag interpretation |
| `&quot;` | " | Inside attribute values |
| `&nbsp;` | (non-breaking space) | Intentional non-breaking space |

## CSS Content Property

When using the CSS `content:` property, accented characters work directly in UTF-8:

```css
/* CORRECT */
.quote::before {
  content: "«";
}
.quote::after {
  content: "»";
}
.required::after {
  content: " (obrigatório)";
}

/* WRONG — no need for escapes when file is UTF-8 */
.required::after {
  content: " (obrigat\00F3rio)";
}
```

## Email HTML — Special Considerations

Some email clients have limited UTF-8 support. For email templates:

1. STILL declare `<meta charset="UTF-8">`
2. Use native characters as the default
3. For maximum compatibility in newsletters targeting older clients, consider both:
   - `Content-Type: text/html; charset=UTF-8` header
   - `<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">`
4. Test with major clients (Gmail, Outlook, Apple Mail) before sending

## Template Engines

Ensure encoding passes through template engines correctly:

- **Jinja2/Nunjucks**: Use `{{ variable }}` — UTF-8 passes through by default
- **Handlebars**: `{{{ variable }}}` (triple braces) for unescaped HTML with accented characters
- **EJS**: `<%- variable %>` for unescaped output with accented characters
- **Pug**: Raw text passes through UTF-8 natively

## Verification Checklist

For every HTML file, verify:
- [ ] `<!DOCTYPE html>` present at line 1
- [ ] `<meta charset="UTF-8">` is first element in `<head>`
- [ ] `lang=""` attribute on `<html>` tag with correct language code
- [ ] No unnecessary HTML entities (á not `&aacute;` when charset is UTF-8)
- [ ] `&amp;`, `&lt;`, `&gt;` kept where syntactically necessary
- [ ] Mixed-language sections have `lang=""` on their containers
- [ ] CSS `content:` values use native characters
