---
name: html-to-pdf
description: Convert HTML files to pixel-perfect PDF using Playwright. Automatically diagnoses and fixes common Chromium PDF rendering issues (blank pages, clip-path breaks, overflow miscalculation). Use when the user wants to convert an HTML file to PDF, or when PDF output has layout problems like blank pages or broken page breaks.
---

# HTML to PDF Conversion Skill

Convert any HTML file to a clean, properly paginated PDF using Playwright browser automation. This skill automatically diagnoses and fixes the most common Chromium PDF rendering bugs.

## When to Use

- User wants to convert an HTML file to PDF
- PDF output has blank pages, broken layouts, or incorrect page breaks
- User needs print-ready PDF from styled HTML documents

## Process

### Step 1: Open and Diagnose

Open the HTML file in Playwright and run a diagnostic scan:

```javascript
// Run this via playwright_evaluate after navigating to the HTML file
const diagnostics = {
  // Check @page margin (CRITICAL - #1 cause of blank pages)
  pageRules: [],
  // Check elements with clip-path (causes page-break miscalculation)
  clipPathElements: [],
  // Check elements with overflow:hidden (creates BFC, blocks page breaks)
  overflowHiddenElements: [],
  // Check large elements with page-break-inside:avoid
  largeAvoidElements: [],
  // Check cover/full-page elements
  fullPageElements: []
};

// Scan @page rules
for (const sheet of document.styleSheets) {
  try {
    for (const rule of sheet.cssRules) {
      if (rule.type === CSSRule.PAGE_RULE) diagnostics.pageRules.push(rule.cssText);
    }
  } catch(e) {}
}

// Scan for problematic elements
document.querySelectorAll('*').forEach(el => {
  const cs = getComputedStyle(el);
  if (cs.clipPath && cs.clipPath !== 'none') {
    diagnostics.clipPathElements.push({
      selector: el.className || el.tagName,
      clipPath: cs.clipPath,
      height: cs.height
    });
  }
  if (cs.overflow === 'hidden' && parseFloat(cs.height) > 100) {
    diagnostics.overflowHiddenElements.push({
      selector: el.className || el.tagName,
      height: cs.height
    });
  }
});
```

Report findings to user before applying fixes.

### Step 2: Apply Universal Fixes

These fixes are ALWAYS safe to apply regardless of HTML structure:

**Fix A: Override @page margin to 0**
```javascript
const pageStyle = document.createElement('style');
pageStyle.textContent = `@page { size: A4; margin: 0; }`;
document.head.appendChild(pageStyle);
```
WHY: CSS `@page { margin: Xmm }` reduces the printable area. If any element (cover page, header) exceeds this reduced height, it overflows to a blank page. Setting margin to 0 gives the full A4 (297mm) printable height. Content elements already have their own padding for margins.

**Fix B: Remove clip-path in print context**
```javascript
document.querySelectorAll('[style*="clip"], *').forEach(el => {
  if (getComputedStyle(el).clipPath !== 'none') {
    el.style.clipPath = 'none';
  }
});
```
Also inject via style tag:
```css
.chapter-header, [class*="header"], [class*="banner"] {
  clip-path: none !important;
  overflow: visible !important;
}
```
WHY: `clip-path` makes Chromium miscalculate element height for page-break decisions. The element occupies full box height in layout but only shows clipped portion visually.

**Fix C: Fix overflow:hidden on layout elements**
```javascript
// Only fix elements that are tall and use overflow:hidden
document.querySelectorAll('*').forEach(el => {
  const cs = getComputedStyle(el);
  if (cs.overflow === 'hidden' && parseFloat(cs.height) > 200) {
    el.style.overflow = 'visible';
  }
});
```
WHY: `overflow: hidden` creates a Block Formatting Context (BFC) that prevents content from breaking across pages.

**Fix D: Remove pseudo-elements that add visual noise**
```css
*::before, *::after {
  /* Only apply to decorative pseudo-elements */
}
.cover-page::before, .cover-page::after,
[class*="header"]::before, [class*="header"]::after {
  display: none !important;
}
```

### Step 3: Apply Conditional Fixes

**If cover/title page exists:**
```javascript
const cover = document.querySelector('.cover-page, .title-page, [class*="cover"]');
if (cover) {
  cover.style.height = '297mm';
  cover.style.maxHeight = '297mm';
  cover.style.minHeight = '0';
  cover.style.boxSizing = 'border-box';
  cover.style.overflow = 'hidden';
}
```

**If elements have negative margins (full-bleed pattern):**
```javascript
// Zero out negative TOP margins only; keep negative side margins for full-bleed
el.style.margin = '0 ' + originalSideMargin + ' 25px ' + originalSideMargin;
```

**If large containers have page-break-inside:avoid:**
Large elements (>800px tall) should use `page-break-inside: auto` to allow splitting across pages. Only small elements (figures, highlight boxes, cards <400px) should use `avoid`.

### Step 4: Generate PDF

```
Use playwright_save_as_pdf with:
- format: A4
- printBackground: true
- margin: { top: "0mm", right: "0mm", bottom: "0mm", left: "0mm" }
```

IMPORTANT: Playwright margin MUST be 0mm to match the injected `@page { margin: 0 }`.

### Step 5: Verify

Read the generated PDF and check:
- Page 1: Does it show the expected content (cover or first section)?
- Page 2: Is it NOT blank? Does content flow properly?
- Last page: Does it end cleanly?

If issues persist, check the diagnostic data from Step 1 and apply more targeted fixes.

## Common Patterns & Solutions

| Symptom | Root Cause | Fix |
|---------|-----------|-----|
| Blank page after cover | `@page margin` > 0 + cover height = 297mm | `@page { margin: 0 }` |
| Header on page alone, rest blank | `clip-path` + `overflow:hidden` on header | `clip-path: none; overflow: visible` |
| Large card pushes to next page | `page-break-inside: avoid` on big element | `page-break-inside: auto` |
| Double margins (too much whitespace) | `@page margin` + content padding both active | `@page { margin: 0 }`, keep content padding only |
| Decorative elements rendering oddly | Pseudo-elements (::before/::after) in print | `display: none !important` on pseudo-elements |

## Key Numbers

- A4: 210mm x 297mm
- A4 at 96 DPI: 794px x 1122.52px
- Always use `box-sizing: border-box` when setting fixed heights

## Permanent HTML Fix

If the user wants to fix the HTML file permanently (not just one-time PDF), update the `@media print` section in the HTML:

```css
@page { size: A4; margin: 0; }

@media print {
    * { -webkit-print-color-adjust: exact; print-color-adjust: exact; }
    body { background: white; }
    .document { box-shadow: none; max-width: none; }

    /* Cover page constraint */
    .cover-page {
        height: 297mm; max-height: 297mm;
        min-height: 0 !important;
        box-sizing: border-box; overflow: hidden;
    }
    .cover-page::before, .cover-page::after { display: none !important; }

    /* Fix clip-path and overflow on headers */
    .chapter-header {
        clip-path: none !important;
        overflow: visible !important;
        position: relative;
        min-height: auto;
    }
    .chapter-header::before, .chapter-header::after { display: none !important; }

    /* Page break rules */
    h2, h3 { page-break-after: avoid; }
    .figure, .highlight-box { page-break-inside: avoid; }
    .content-card { page-break-inside: auto; }  /* Large containers must be breakable */
}
```
