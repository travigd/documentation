# Event Store Documentation

**This documentation is available at [http://docs.geteventstore.com](http://docs.geteventstore.com).** The website is hosted using [GitHub Pages](https://pages.github.com) from the `gh-pages` branch of this repository. Pages are automatically built with [Jekyll](http://jekyllrb.com) using the [Redcarpet](https://github.com/vmg/redcarpet) complier.

## Versioning

The Event Store documentation is available for multiple versions of Event Store and its APIs. By default the website shows documentation for the latest stable release of each component. Current sections and versions are:

| Section      | Versions                           |
| :----------- | :--------------------------------- |
| Introduction | Not versioned, always shows latest |
| Server       | 3.0.1 (latest), 3.0.0              |
| .NET API     | 3.0.1 (latest), 3.0.0              |
| HTTP API     | 3.0.1 (latest), 3.0.0              |

## Conventions

### File Names

- File and directory names are all lowercase.
- Spaces are replaced with dashes.
- Markdown files take the `.md` extension.

For example:

```
/dotnet-api/3.0.0/writing-to-a-stream.md
```

### URLs

Published pages should be available at a URL with one of these formats:

- `http://docs.geteventstore.com/index.html`
- `http://docs.geteventstore.com/[SECTION]/index.html`
- `http://docs.geteventstore.com/[SECTION]/[VERSION]/index.html`
- `http://docs.geteventstore.com/[SECTION]/[VERSION]/[FILENAME]/index.html`

For example:

```
http://docs.geteventstore.com/dotnet-api/3.0.0/writing-to-a-stream/index.html
```

### Front Matter

Every page written for Jekyll in markdown has front matter, which specifies information about the page. We specify a title for the page, the section it belongs to, and the version for that section. Title and section should be [title case](http://en.wiktionary.org/wiki/title_case), and the version number should be in the format X.X.X.

For example:
```jekyll
---
title: "Writing to a Stream"
section: ".NET API"
version: "3.0.0"
---

Lorem ipsum dolor sit amet…
```