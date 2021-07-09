# Rouge Lexer for PML

![Lexer Status][Status badge]&nbsp;
[![PML Version][PML badge]][Get PML]&nbsp;
[![Rouge Version][Rouge badge]][Rouge]&nbsp;
[![Asciidoctor Version][Asciidoctor badge]][Asciidoctor]&nbsp;
[![Sass Version][Sass badge]][Dart Sass]&nbsp;

Custom PML lexer for [Rouge], plus [Asciidoctor] assets and [Sass]/CSS themes for the HTML backend.


-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Directory Contents](#directory-contents)
- [Acknowledgements](#acknowledgements)
- [Credits](#credits)
    - [Gogh Flat](#gogh-flat)
- [Links](#links)
    - [Rouge](#rouge)
    - [Asciidoctor](#asciidoctor)

<!-- /MarkdownTOC -->

-----

# Directory Contents

- [`/sass/`][sass/] — Custom Sass/CSS PML themes for Asciidoctor HTML.
- [`pml-sample.pml`][sample pml] — sample PML source.

Custom Ruby scripts, lexers and themes for [Rouge]:

- [`pml.rb`][pml.rb] — custom Rouge lexer for PML (WIP).
- [`custom-rouge-adapter.rb`][adapter] — tweaks the Rouge adapter for Asciidoctor that loads (requires) our `pml.rb` lexer and theme.
- [`pml-test-theme.rb`][theme.rb] — custom Rouge theme for testing PML.

Sample documents:

- [`asciidoctor-example.asciidoc`][example adoc] — Asciidoctor example document.
- [`asciidoctor-example.html`][example html] — converted HTML doc ([Live HTML Preview][example live])
- [`pml-syntax.asciidoc`][syntax adoc] — Asciidoctor test document for the PML lexer.
- [`pml-syntax.html`][syntax html] — converted HTML doc ([Live HTML Preview][syntax live])
- [`docinfo.html`][docinfo.html] — Asciidoctor [docinfo file] with our custom CSS (generated via [`sass/build.sh`][sass/build.sh]).
- [`build.sh`][build.sh] — converts all documents to HTML using our custom `pml.rb` lexer and assets.


# Acknowledgements

I'd like to express my gratitude to [Dan Allen]  (@mojavelinux) from the [Asciidoctor Project] for helping me out on how to make Rouge require a custom lexer:

- [asciidoctor#4080]

# Credits

Third party components and assets used in this directory tree.

## Gogh Flat

Our custom syntax highlighter theme uses [Gogh]'s __Flat__ colour scheme:

- https://github.com/Mayccoll/Gogh/blob/master/themes/flat.sh

which was based on the __Flat UI Terminal Theme__ by [Ahmet Sülek]:

- https://dribbble.com/shots/1021755-Flat-UI-Terminal-Theme
- https://github.com/ahmetsulek/flat-terminal

whose colours were based on the __Flat UI kit__ by [Designmodo], released under MIT License:

- https://designmodo.github.io/Flat-UI
- https://github.com/designmodo/Flat-UI

```
The MIT License

Copyright (c) 2013-2018 Designmodo

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
```


-------------------------------------------------------------------------------

# Links

## Rouge

- [Rouge website][Rouge]
- [Rouge repository]
- [Rouge Tokens List]
- [Rouge Wiki]
- [Rouge documentation]
- [Redcarpet]

## Asciidoctor

- [Asciidoctor website][Asciidoctor]
- [Asciidoctor repository]:
    + [`rouge.rb`][rouge.rb] — Asciidoctor's native API for Rouge.
    + [asciidoctor#4080] — Rouge Highlighter: Add 'rouge-require' Option for Custom Lexers and Themes
- [Asciidoctor Documentation]:
    + [Syntax Highlighting][AsciiDr Syntax Highlighting]:
        * [Rouge][AsciiDr Rouge]
        * [Custom Syntax Highlighter Adapter]


<!-----------------------------------------------------------------------------
                               REFERENCE LINKS
------------------------------------------------------------------------------>

[Sass]: https://sass-lang.com/dart-sass "Learn more about Dart Sass (Syntactically Awesome Style Sheets)"
[Dart Sass]: https://github.com/sass/dart-sass "Visit Dart Sass repository on GitHub"

[Gogh]: https://mayccoll.github.io/Gogh/ "Visit Gogh website"

<!-- PML -->

[Get PML]: https://www.pml-lang.dev/downloads/install.html "Go to the PML download page"

<!-- Rouge -->

[Rouge]: http://rouge.jneen.net "Rouge website"
[Rouge repository]: https://github.com/rouge-ruby/rouge "Rouge repository on GitHub"
[Rouge documentation]: https://rouge-ruby.github.io/docs/ "Rouge online documentation"
[Rouge Wiki]: https://github.com/rouge-ruby/rouge/wiki "Rouge Wiki on GitHub"

[Rouge Tokens List]: https://htmlpreview.github.io/?https://github.com/alan-if/Alan-Testbed/blob/master/syntax-hl/Rouge/themes/Rouge-Tokens.html "List of Rouge tokens and their CSS classes"

[cli.rb]: https://github.com/rouge-ruby/rouge/blob/master/lib/rouge/cli.rb#L235 "View source file at Rouge repository"

<!-- Asciidoctor -->

[Asciidoctor]: https://asciidoctor.org "Asciidoctor website"
[Asciidoctor repository]: https://github.com/asciidoctor/asciidoctor "Asciidoctor repository on GitHub"
[rouge.rb]: https://github.com/asciidoctor/asciidoctor/blob/master/lib/asciidoctor/syntax_highlighter/rouge.rb

[Asciidoctor Documentation]: https://docs.asciidoctor.org/asciidoctor/latest/
[docinfo file]: https://docs.asciidoctor.org/asciidoctor/latest/docinfo/ "Asciidoctor Manual » Docinfo Files"
[AsciiDr Syntax Highlighting]: https://docs.asciidoctor.org/asciidoctor/latest/syntax-highlighting/
[AsciiDr Rouge]: https://docs.asciidoctor.org/asciidoctor/latest/syntax-highlighting/rouge/
[Custom Syntax Highlighter Adapter]: https://docs.asciidoctor.org/asciidoctor/latest/syntax-highlighting/custom/

<!-- 3rd Party tools -->

[asciidoctor-pdf]: https://github.com/asciidoctor/asciidoctor-pdf "asciidoctor-pdf repository on GitHub"
[Redcarpet]: https://github.com/vmg/redcarpet "Redcarpet repository on GitHub"

<!-- badges -->

[Status badge]: https://img.shields.io/badge/status-WIP-orange "Lexer status: WIP Alpha"
[PML badge]: https://img.shields.io/badge/PML-1.5.0-yellow "Supported PML version (click for PML download page)"
[Rouge badge]: https://img.shields.io/badge/Rouge-3.26.0-yellow "Supported Rouge version (click to visit Rouge website)"
[Asciidoctor badge]: https://img.shields.io/badge/Asciidoctor-2.0.15-yellow "Supported Asciidoctor version (click to visit Asciidoctor website)"
[Sass badge]: https://img.shields.io/badge/Dart%20Sass-1.35.1-yellow "Supported Dart Sass version (click to visit Dart Sass repository)"

<!-- project files and folders -->

[sass/]: ./sass/ "Navigate to Sass/SCSS folder"
[sass/build.sh]: ./sass/build.sh "View Sass/CSS and docinfo builder script"

[sample pml]: ./pml-sample.pml "View PML sample source doc"

[build.sh]: ./build.sh "View build script"

[example adoc]: ./asciidoctor-example.asciidoc "Asciidoctor example (source doc)"
[example html]: ./asciidoctor-example.html "Asciidoctor example (generated HTML doc)"
[example live]: https://htmlpreview.github.io/?https://github.com/tajmone/pml-playground/blob/master/syntax-hl/rouge/asciidoctor-example.html "Live HTML Preview of 'asciidoctor-example.html'"

[syntax adoc]: ./pml-syntax.asciidoc "'PML Syntax' Asciidoctor (source doc)"
[syntax html]: ./pml-syntax.html "'PML Syntax' Asciidoctor (generated HTML doc)"
[syntax live]: https://htmlpreview.github.io/?https://github.com/tajmone/pml-playground/blob/master/syntax-hl/rouge/pml-syntax.html "Live HTML Preview of 'pml-syntax.html'"

[adapter]: ./custom-rouge-adapter.rb "Custom Rouge adapter for Asciidoctor"
[pml.rb]: ./pml.rb "Rouge's PML Lexer source"
[theme.rb]: ./pml-test-theme.rb "Rouge's test theme for PML Lexer"
[docinfo.html]: ./docinfo.html "Asciidoctor docinfo file"

<!-- Issues -->

[asciidoctor#4080]: https://github.com/asciidoctor/asciidoctor/issues/4080 "Rouge Highlighter: Add 'rouge-require' Option for Custom Lexers and Themes"

<!-- people and orgs -->

[Ahmet Sülek]: https://github.com/ahmetsulek "View Ahmet Sülek's GitHub profile"
[Dan Allen]: https://github.com/mojavelinux "View Dan Allen's GitHub profile"

[Asciidoctor Project]: https://github.com/asciidoctor "View the Asciidoctor Project organization profile on GitHub"
[Designmodo]: https://github.com/designmodo "View Designmodo's GitHub profile"

<!-- EOF -->