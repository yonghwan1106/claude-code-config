# HTML to PDF Conversion via Playwright — Lessons Learned

## Root Causes of Blank Pages in PDF

### 1. `@page { margin }` reduces printable area
- `@page { margin: 18mm }` → printable height = 297mm - 36mm = **261mm**
- If a cover page is set to `height: 297mm` or `min-height: 297mm`, it overflows by 36mm into a second page
- **Fix**: Use `@page { margin: 0 }` and let content elements provide their own padding/margins

### 2. `clip-path` + `overflow: hidden` breaks page-break calculation
- Chromium's PDF engine miscalculates page breaks when elements have `clip-path: polygon(...)` combined with `overflow: hidden`
- Elements appear to occupy more space than they visually display
- **Fix**: In `@media print`, add `clip-path: none !important; overflow: visible !important;`

### 3. `page-break-inside: avoid` on large elements
- If an element (e.g., `.content-card`) is taller than remaining page space, `page-break-inside: avoid` pushes it entirely to the next page
- This leaves the current page with only the chapter header and blank space below
- **Fix**: Use `page-break-inside: auto` for large container elements; only use `avoid` on small elements (figures, highlight boxes)

### 4. Negative margins on chapter headers
- Patterns like `margin: -25mm -28mm 35px -28mm` (negative top/sides to achieve full-bleed) can confuse pagination
- **Fix**: In print mode, use `margin: 0 -28mm 25px -28mm` (zero top margin, keep negative sides for full-bleed)

## Recommended `@media print` Template

```css
@page { size: A4; margin: 0; }

@media print {
    body { background: white; }
    .document { box-shadow: none; max-width: none; }
    * {
        -webkit-print-color-adjust: exact;
        print-color-adjust: exact;
    }
    .cover-page {
        min-height: 0 !important;
        height: 297mm;
        max-height: 297mm;
        box-sizing: border-box;
        overflow: hidden;
    }
    .cover-page::before,
    .cover-page::after {
        display: none !important;
    }
    .chapter-header {
        clip-path: none !important;
        overflow: visible !important;
        position: relative;
        margin: 0 -28mm 25px -28mm;  /* zero top margin */
        min-height: auto;
    }
    .chapter-header::before,
    .chapter-header::after {
        display: none !important;
    }
    .content-page {
        padding: 20mm 28mm 18mm 28mm;
    }
    /* Only avoid breaks on SMALL elements */
    .figure, .highlight-box, .info-card {
        page-break-inside: avoid;
    }
    /* Large containers MUST be breakable */
    .content-card {
        page-break-inside: auto;
    }
}
```

## Playwright PDF Settings

```javascript
await page.pdf({
    path: 'output.pdf',
    format: 'A4',
    printBackground: true,
    margin: { top: '0mm', right: '0mm', bottom: '0mm', left: '0mm' }
});
```

## Debugging Tips
- Use `page.evaluate()` to check `getComputedStyle()` of problematic elements
- Check actual element heights vs A4 page height (1122.52px at 96 DPI = 297mm)
- `@media print` rules are only applied during actual print/PDF generation, NOT visible in screen-mode computed styles
- If `@media print` CSS alone doesn't work, use DOM manipulation via `element.style` as fallback
