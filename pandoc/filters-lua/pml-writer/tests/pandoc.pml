[doc [title Pandoc Markdown]
     [subtitle Sample document]

Tristano Ajmone, Author Two |
2022-02-06


This WIP document provides examples of how pandoc-markdown features are converted to PML via the [c pml-writer].
As new PML elements are implemented in the writer, their examples will be added to the document.

For more info, refer to the [link url=https://pandoc.org/MANUAL.htm text="Pandoc User’s Guide"].

[ch [title Block Elements]

[ch [title Block Quotations]

[list
[el See: [link url=https://pandoc.org/MANUAL.htm text="Pandoc User’s Guide"] » [link url=https://pandoc.org/MANUAL.html#block-quotations text="Block quotations"]]
]

[html
<!-- end of list -->
html]

[quote
Strange women lying in ponds distributing swords is no basis for a system of government.

Supreme executive power derives from a mandate from the masses, not from some farcical aquatic ceremony.
]

][ch [title Code blocks]

[list
[el See: [link url=https://pandoc.org/MANUAL.htm text="Pandoc User’s Guide"] » [link url=https://pandoc.org/MANUAL.html#verbatim-code-blocks text="Verbatim (code) blocks"]]
]

[ch [title Fenced code blocks]

[list
[el See: [link url=https://pandoc.org/MANUAL.htm text="Pandoc User’s Guide"] » [link url=https://pandoc.org/MANUAL.html#fenced-code-blocks text="Fenced code blocks"]]
]

[code
function HorizontalRule()
  return '[html\n<hr/>\nhtml]'
end
code]


]][ch [title Lists]

[list
[el See: [link url=https://pandoc.org/MANUAL.htm text="Pandoc User’s Guide"] » [link url=https://pandoc.org/MANUAL.html#lists text="Lists"]]
]

[ch [title Bullet Lists]

[list
[el Bold: [b Lorem ipsum].]
[el Italic: [i Lorem ipsum].]
[el Code: [c Lorem ipsum].]
]

][ch [title Ordered Lists]

[list (html_style="list-style-type:decimal")
[el AAA

[list (html_style="list-style-type:decimal")
[el Sub-element 1.

[list (html_style="list-style-type:decimal")
[el Sub-sub-element.]
]]
[el Sub-element 2.]
]]
[el BBB]
[el CCC]
[el DDD]
]

]][ch [title Horizontal Rules]

[list
[el See: [link url=https://pandoc.org/MANUAL.htm text="Pandoc User’s Guide"] » [link url=https://pandoc.org/MANUAL.html#horizontal-rules text="Horizontal rules"]]
]

PML doesn’t support horizontal rules, so the element is rendered via raw HTML.

[html
<hr/>
html]

]][ch [title Inline Elements]

[ch [title Font Styles]

[list
[el See: [link url=https://pandoc.org/MANUAL.htm text="Pandoc User’s Guide"] » [link url=https://pandoc.org/MANUAL.html#inline-formatting text="Inline formatting"]]
]

These text formatting styles are natively supported by pandoc Markdown syntax:

[list
[el Some [b bold] text.]
[el Some [i italic] text.]
[el Some [c inline code] text.]
[el Some [sup superscript] text.]
[el Some [sub subscript] text.]
[el Some [strike strikeout] text.]
]

Pandoc also supports underline and small caps via custom classes and CSS:

[code
[Underline]{.underline}
[Small caps]{.smallcaps}
code]


][ch [title Links]

[list
[el See: [link url=https://pandoc.org/MANUAL.htm text="Pandoc User’s Guide"] » [link url=https://pandoc.org/MANUAL.html#links-1 text="Links"]]
]

Currently the PML writer discards links attributes and title, which will need to be handled in the future.

[list
[el Automatic link: [link url=https://www.pml-lang.dev text="https://www.pml-lang.dev"]]
[el Inline link: [link url=https://www.pml-lang.dev/docs/reference_manual/index.html text="PML Reference Manual"]]
]

[ch [title Empty Links]

The PML Writer corrects empty links by rendering the link text only:

[list
[el an empty link]
]

]][ch [title Images]

[list
[el See: [link url=https://pandoc.org/MANUAL.htm text="Pandoc User’s Guide"] » [link url=https://pandoc.org/MANUAL.html#images text="Images"]]
]

[quote
[b WARNING] — PML doesn’t support external images via HTTP! so we’ll be testing only with local images.
]

[ch [title Inline Images]

Images are considered by pandoc to be inline if they are not the only element in a paragraph.

An inline image: [image source="./pml-cool.png"]

An inline image with alt-text: [image source="./pml-cool.png" html_title="Alt-text is cool too!"]

][ch [title Captioned Images]

[image source="./pml-cool.png" caption="The PML cool image" html_alt="The PML cool image"]

Captioned image without caption:

[image source="./pml-cool.png"]

[html
<!----------------------------- REFERENCE LINKS ------------------------------>
html]

[html
<!-- EOF -->
html]


]
]
]

]
