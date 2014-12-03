# Event Store Documentation

> **This documentation is available at [http://docs.geteventstore.com](http://docs.geteventstore.com).** The website is hosted using [GitHub Pages](https://pages.github.com) from the `gh-pages` branch of this repository. Pages are automatically built with [Jekyll](http://jekyllrb.com) using the [Redcarpet](https://github.com/vmg/redcarpet) complier.
>
> What follows is documentation for how to use the Event Store documentation. It’s really meta. If you’re planning to make updates or contributions then read on; otherwise head on over to the [website](http://docs.geteventstore.com).

## How to Contribute

### Small Edits

If you notice a mistake in our docs, or if you feel you have a better way of explaining some concept described therein, please send us a pull request on this repository with the edits made. Be aware that any errors you correct may be present in earlier versions, so check those too and edit as appropriate.

### New Pages and Sections

New pages and sections can be added. Follow the [conventions](#conventions) below.

### Moving to a New Version

Sections can be versioned.

1. Make copy of the latest version’s directory and rename it to reflect the latest version number. For example, copy `server/3.0.0` to `server/3.0.1`.
   > Pre-release documentation should be denoted with `-pre` on the version number, like `server/3.0.1-pre`
2. In the new version’s directory update all `.md` files to include the new version number in the front matter.

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
```markdown
---
title: "Writing to a Stream"
section: ".NET API"
version: "3.0.0"
---

Lorem ipsum dolor sit amet…
```