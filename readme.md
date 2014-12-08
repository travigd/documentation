# Event Store Documentation

> **This documentation is available at [http://docs.geteventstore.com](http://docs.geteventstore.com).** The website is hosted using [GitHub Pages](https://pages.github.com) from the `gh-pages` branch of this repository. Pages are automatically built with [Jekyll](http://jekyllrb.com) using the [Redcarpet](https://github.com/vmg/redcarpet) complier.
>
> What follows is documentation for how to use the Event Store documentation. It’s really meta. If you’re planning to make updates or contributions then read on; otherwise head on over to the [website](http://docs.geteventstore.com).

## Versioning

The Event Store documentation is available for multiple versions of Event Store and its APIs. By default the website shows documentation for the latest stable release of each component. Current sections and versions are:

| Section      | Versions              |
| :----------- | :-------------------- |
| Introduction | Always shows latest   |
| Server       | 3.0.1 (latest), 3.0.0 |
| .NET API     | 3.0.1 (latest), 3.0.0 |
| HTTP API     | 3.0.1 (latest), 3.0.0 |

## How to Contribute

### Running Jekyll Locally

This documentation is rendered by GitHub Pages using Jekyll. If you want to generate the site locally and test your changes, you will need to follow the instructions [here](https://help.github.com/articles/using-jekyll-with-pages/#installing-jekyll) to get Jekyll installed.

Once installed, navigate to the root of the repository and run `jekyll build`. The site will be generated into a folder named `_site`.

Jekyll can also automatically rebuild the site as you save changes to the source files. Simply use `jekyll build --watch`.

### Small Edits

1. Make changes (fix typos or grammar, improve wording etc).
2. Check to see if older versions need updating too.
3. Send a pull request!

### New Pages and Sections

1. Create new pages and/or sections. Follow the [Conventions](#conventions) below.
2. If you create a new section, add an entry for it to the `top_level_sections` list on `_config.yml` in an appropriate place (this list determines the order the sections are listed in the navigation sidebar).
3. Add any new sections to the table at the top of this README.
4. Send a pull request!

### Creating a New Version

1. Duplicate the section’s latest version directory and rename it to reflect the latest version number. For example, copy `/server/3.0.0/` to `/server/3.0.1/`.

   > Pre-release documentation should be denoted with `-pre` after the version number, like `/server/3.0.1-pre/`. This way the documentation will show up on the website, but won’t be the default version.
2. In the new version’s directory update all `.md` files to include the new version number in the front matter (see [Front Matter](#front-matter) below).
3. Make edits to files in the new version as appropriate. Pages can be created or deleted when necessary.
4. To change the default version of a section (i.e. the one that displays when you visit the un-versioned URL) edit the `index.md` file in the section root to reflect the new version number.

   For example, if you were moving the `dotnet-api` section to `3.0.1` you would edit `/dotnet-api/index.md` to include the line `latest-version: 3.0.1`. Now users who visit

   ```
   http://docs.geteventstore.com/dotnet-api/
   ```

   will be redirected to

   ```
   http://docs.geteventstore.com/dotnet-api/3.0.1/
   ```
4. Update the version table at the top of this README.
5. Send a pull request!

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

Every page written for Jekyll in markdown has front matter, which specifies information about the page. We specify a title for the page, the section it belongs to, and the version for that section. Title and section should be [title case](http://en.wiktionary.org/wiki/title_case), and the version number should be in the format `X.X.X`.

For example:
```markdown
---
title: "Writing to a Stream"
section: ".NET API"
version: "3.0.0"
---

Lorem ipsum dolor sit amet…
```

For `index.md` pages you should also include `pinned: true`.

### Formatting and Typesetting

The content of our documentation is written by many developers. These formatting guidelines should help us maintain a consistent use of language throughout the docs.

- **Acronyms and abbreviations** should always be set in uppercase (e.g. API, HTTP, JVM)
- **Brand names** should be capitalised correctly (e.g. Event Store, JavaScript, .NET)
- **Example code** should not have a line length of more than 80 characters
