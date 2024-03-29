# PML Lua Writer Status

Overall progress of the pandoc filter, pending tasks and known issues.

> **WARNING** — This status report is far from complete!
> Many implemented elements are omitted, as well as elements pending implementation.
>
> Currently, this document serves mostly as a memo for the features being worked upon.


-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Doc Nodes/Elements](#doc-nodeselements)
    - [Source Code Annotations](#source-code-annotations)
- [Missing Features](#missing-features)
    - [Metadata](#metadata)
    - [TOC Settings](#toc-settings)
- [Known Issues](#known-issues)
    - [Links Text](#links-text)
    - [List Start Number](#list-start-number)
    - [HTML Attributes](#html-attributes)
    - [TeX Math Support](#tex-math-support)
- [Code Improvements and Sanitation](#code-improvements-and-sanitation)

<!-- /MarkdownTOC -->

-----

# Doc Nodes/Elements

Status of pandoc AST nodes conversion functions, by function names to ease source look-up.

- [x] `BlockQuote()`
- [x] `BulletList()` — works, but not 100% complete.
- [x] `CaptionedImage()`
- [ ] `Cite()`
- [x] `Code()` &rarr; `[c` — works, but discards attributes.
- [x] `CodeBlock()` — work, but needs polishing.
- [ ] `DefinitionList()` &rarr; no PML equivalent!
- [x] `DisplayMath()` &rarr; `[verbatim` — requires [MathJax] JS library (See: [PMLC #92]).
- [ ] `Div()`
- [x] `DoubleQuoted()` &rarr; via literal `“` and `”` curly quote characters.
- [x] `Emph()`
- [x] `Header()`
- [x] `HorizontalRule()` &rarr; `[html` + `<hr/>`
- [x] `Image()`
- [x] `InlineMath()` &rarr; `[verbatim` — requires [MathJax] JS library (See: [PMLC #92]).
- [ ] `LineBlock()`
- [x] `LineBreak()` &rarr; `[nl]`
- [x] `Link()` — works, but discards title and attributes.
- [x] `Note()` &rarr; `[fnote_ref` and `[fnote_def`
- [x] `OrderedList()` — fails due to PMLC bug, but code is there.
- [ ] `Para()`
- [ ] `Plain()`
- [x] `RawBlock()` — only HTML contents are preserved.
- [x] `RawInline()` &rarr; `[verbatim` — only HTML contents are preserved.
- [x] `SingleQuoted()` &rarr; via literal `‘` and `’` curly quote characters.
- [x] `SmallCaps()` &rarr; `[span (html_style=`
- [x] `SoftBreak()` &rarr; `\n`
- [x] `Space()`
- [ ] `Span()` &rarr; `[span` — WIP, but HTML Attributes are suppressed to due PMLC bug (See: [PMLC #91]).
- [x] `Str()`
- [x] `Strikeout()`
- [x] `Strong()`
- [x] `Subscript()`
- [x] `Superscript()`
- [x] `Table()` — works, but discards columns alignment and width info.
- [x] `Underline()` &rarr; `[span (html_style=`

## Source Code Annotations

In `pml-writer.lua`, pandoc AST element functions which haven't yet been adapted, or which are not completed, are preceded by a comment line starting with `-- @TDB:` or `-- @WIP:`, respectively, and followed by the element function name. E.g.

```lua
-- @TBD:Subscript()
-- @WIP:SoftBreak()
```

Similarly, any piece of code requiring developers' attention is marked with a comment in the form `-- @[A-Z]:` (e.g. `-- @NOTE:`, `-- @TODO:`, etc.) to allow quick navigation of pending issues via editor Search functionality.


# Missing Features

Aspects of the document format conversion which still need to be looked into.

## Metadata

Pandoc handles complex metadata info, but PML doesn't yet provide this feature, so we need to work out ways to avoid loss of meaningful metadata entries:

- [x] **author** & **date** — currently emitted as first paragraph:

      ```
      <author> | <date>
      ```

- [ ] _other_? — study what other metadata is worth keeping.

## TOC Settings

Some of pandoc TOC settings should be portable to PML via `[doc [options` sub-nodes, although most of these settings are not a priority (with the exception of the TOC title).

- [ ] **TOC title** &rarr; `[TOCTitle`
- [ ] **TOC position**? &rarr; `[TOCPosition `


# Known Issues

Problems that need addressing and which we are already aware of.

## Links Text

When rendering links as `[link` nodes, if we escape the contents of the `text` attributes it will also escape any formatting nodes therein, so I temporarily skipped escaping altogether, in order to preserve the tags.

But I noticed that the resulting PML code is not being styled, and I'm not sure if it's because the `[link` node doesn't support further styling. In any case, since pandoc supports styles in links text, I'll have to address the problem, by either:

- correctly styling link text according to PML rules,
- stripping away the styles, or
- rendering the links as raw HTML (when styled only?)

## List Start Number

The code that handles the list `start` attribute has been implemented in the filter, but it had to be circumvented because `html_start` crashes PMLC 3.1.0 due to a bug. (See: [PMLC #91])

## HTML Attributes

Currently, due to the PMLC 3.1.0 bug mentioned in [PMLC #91], which crashes PMLC when a node has multiple HTML attributes, we had to temporary suppress emitting HTML attributes in the output. This is affecting:

- `Span()` and [text highlighting via `.mark`](https://pandoc.org/MANUAL.html#highlighting)

## TeX Math Support

- See: [PMLC #92].

[TeX math] contents are passed through to HTML via a `[verbatim` node (inline math) or via an `[html` node (display math), which work fine but require the [MathJax] JS library.

Currently, it's the end user who needs to take care of adding the [MathJax] dependency to HTML document, but we might consider having our PML writer take care of this when TeX math contents are present — we can easily track if the `DisplayMath()` or `InlineMath()` functions were called within a document, and inject the required raw HTML accordingly:

```html
<script type="text/javascript" id="MathJax-script" async
  src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js">
</script>
```

This is how our `elements/math.markdown` test works, we simply include the above as a raw HTML block, within the document body, and it works just fine after the markdown-to-PML and PML-to-HTML conversions.

But if we could find a way to inject that code in the HTML header it would be much better, but I'm not sure if and how this can be achieved with the current PMLC — if the process requires using custom header template files, it's just not worth the effort.

Also, this might soon be resolved if PML introduces dedicated nodes for math notation support (see [PMLC #92] on this).


# Code Improvements and Sanitation

The Lua writer code could still be optimized, and there are aspects of the conversion process which haven't been fully tested yet.

- [ ] **PML Node Functions** — Some pandoc elements result in common PML nodes, so we might benefit from creating dedicated functions for emitting PML nodes:
    + [x] `[caption` &rarr; `pml_node_caption()` — shared by images, tables, and maybe other pandoc elements.
    + [x] `[html`  &rarr; `pml_node_html()` — raw HTML nodes are used by elements which have no PML counterpart, but can also be used as a temporary solution for unported elements, so that the filter can be used even if not fully implemented.
    + [x] `[verbatim` &rarr; `pml_node_verbatim()` — raw inline HTML needs to be rendered via `[verbatim` to preserve contents flow.
- [ ] **Contents Filtering** — since the filter is based on the Lua sample filter for an HTML writer, all element functions need to be checked to ensure that node contents and attributes values are handled properly according to PML rules.
    + [ ] **Contents escaping** — [node escaping rules] are handled via `escape()`, which has been quickly adapted to cover PML escaping rules, but its code might need improvements, and also the way its currently used is based on the sample filter and its needs for HTML:
        * [ ] Rename `escape()` to `node_escape()`.
        * [ ] Ensure that all pandoc element functions are correctly invoking the node escaping function, based on PML needs instead of HTML.
    + [ ] **Attributes escaping** — [attributes escaping rules] differ slightly, and only apply to quoted attributes. Currently the filter is not taking care of ensuring that quoted attributes are escaped at all.
        * [ ] Create `attr_escape()` function.
- [ ] **Comments preservation** — markdown files can contain HTML comments, so it would be nice to be able to preserve them by converting them into PML comments.
    + [ ] Find out how HTML comments are represented in the AST. Are they Raw nodes?
    + [ ] What other input formats might carry comments? (i.e. other than HTML)
    + [ ] Find comments examples in pandoc native format to add to test suite.


<!-----------------------------------------------------------------------------
                               REFERENCE LINKS
------------------------------------------------------------------------------>

[attributes escaping rules]: https://www.pml-lang.dev/docs/user_manual/index.html#attribute_escape_characters "PML User Manual » Escape Characters » Attributes"

[node escaping rules]: https://www.pml-lang.dev/docs/user_manual/index.html#node_escape_characters "PML User Manual » Escape Characters » Nodes"

<!-- pandoc refs -->

[TeX math]: https://pandoc.org/MANUAL.html#math "Pandoc Manual » Math"

<!-- 3rd party -->

[MathJax]: https://www.mathjax.org "Visit MathJax website"

<!-- Issues & Discussions -->

[PMLC #91]: https://github.com/pml-lang/pml-companion/issues/91 "PMLC Issue #91 — Bug in PMLC 3.1.0 causes crash with multiple HTML attributes"
[PMLC #92]: https://github.com/pml-lang/pml-companion/issues/92 "PMLC Discussion #92 — TeX Math Support"

<!-- EOF -->
