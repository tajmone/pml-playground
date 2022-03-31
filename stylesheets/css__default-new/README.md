# New Default Style Sheet

An attempt to reorganize the default CSS according to [SMACSS] guidelines, using Sass sources, and improving the styles at the same time.

-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [About](#about)
- [TODOs](#todos)

<!-- /MarkdownTOC -->

-----

# About

These Sass stylesheets were recreated starting off from the original PML 2.3.0 CSS files:

- `pml-default.css` &rarr; renamed to: `pml-default.scss`
- `pml-print-default.css` &rarr; renamed to: `pml-print-default.scss`

The contents of `pml-print-default.scss` have been temporarily commented out to avoid possible interferences with the main stylesheet.

# TODOs

- [ ] `pml-default.scss`:
    + [ ] Split CSS rules into modules according to SMACSS rules:
        * [ ] Base
        * [ ] Layout
        * [ ] Module
        * [ ] State
        * [ ] Theme
    + [ ] Improve CSS:
        * [ ] Vertical rhythm.
        * [ ] Media queries for smaller screens.
- [ ] `pml-print-default.scss`:
    + [ ] Temporarily comment them out to avoid interference with basic stylesheet.
    + [ ] ???



<!-----------------------------------------------------------------------------
                               REFERENCE LINKS
------------------------------------------------------------------------------>

[SMACSS]: http://smacss.com "SMACSS website + free book"


<!-- EOF -->
