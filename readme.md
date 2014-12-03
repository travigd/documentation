# Event Store Documentation

This documentation is available at [http://docs.geteventstore.com](http://docs.geteventstore.com).

The website is hosted using [GitHub Pages](https://pages.github.com) from the gh-pages branch of this repository. Pages are built with [Jekyll](http://jekyllrb.com) using the [Redcarpet](https://github.com/vmg/redcarpet) complier.

## Conventions

### File Naming

- File names are all lowercase.
- Spaces are replaced with dashes (e.g. `dotnet-api.md`).
- Markdown files take the `.md` extension.

### Front Matter

Every page written in markdown has front matter, which specifies information about the page to Jekyll. We specify a title for the page, the section it belongs to, and the version for that section. Title and section should be [title case](http://en.wiktionary.org/wiki/title_case), and the version number should be in the format X.X.X.

For example:
```jekyll
---
title: "Writing to a Stream"
section: ".NET API"
version: "3.0.0"
---
```