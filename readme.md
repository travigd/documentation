# Event Store Documentation

**This documentation is available at [http://docs.geteventstore.com](http://docs.geteventstore.com).** The website is hosted using [GitHub Pages](https://pages.github.com) from the `gh-pages` branch of this repository. Pages are automatically built with [Jekyll](http://jekyllrb.com) using the [Redcarpet](https://github.com/vmg/redcarpet) complier.

## Conventions

### File Names

- File and directory names are all lowercase.
- Spaces are replaced with dashes.
- Markdown files take the `.md` extension.

For example:

```
/api/dotnet/3.0.0/writing-to-a-stream.md
```

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