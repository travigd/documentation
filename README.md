# Event Store Documentation

**This documentation is available at [http://docs.geteventstore.com](http://docs.geteventstore.com).** The website is hosted using [GitHub Pages](https://pages.github.com) from the `gh-pages` branch of this repository. Pages are built with [Jekyll](http://jekyllrb.com) using the [Redcarpet](https://github.com/vmg/redcarpet) complier.

What follows is documentation for how to use the Event Store documentation. If you’re planning to make updates or contributions then read on. Otherwise, head on over to the [website](http://docs.geteventstore.com).

## Versioning

The Event Store documentation is available for many versions of Event Store and its APIs. By default the website shows documentation for the latest stable release of each component. Current sections and versions are:

| Section      | Versions                                                        |
| :----------- | :-------------------------------------------------------------- |
| Introduction | Always shows latest                                             |
| Server       | 3.4.0 (latest), 3.3.0, 3.2.0, 3.1.0, 3.0.5, 3.0.3, 3.0.2, 3.0.1, 3.0.0 |
| .NET API     | 3.4.0 (latest), 3.2.0, 3.1.0, 3.0.2, 3.0.1, 3.0.0                      |
| HTTP API     | 3.4.0 (latest), 3.2.0, 3.1.0, 3.0.3, 3.0.2, 3.0.1, 3.0.0               |

The Event Store server uses [semantic versioning](http://semver.org). API versions are based on the major server version they support.

## How to Contribute

### Running Jekyll Locally

GitHub Pages renders this documentation using Jekyll. You can generate the site locally and test your changes. Follow the instructions [here](https://help.github.com/articles/using-jekyll-with-pages/#installing-jekyll) to get Ruby and Bundler installed.

Once installed, navigate to the root of the repository and run

`bundle install`
followed by
`bundle exec jekyll serve`

The compiled site builds into `/_site` and is hosted at `http://localhost:4000`.

### Small Edits

1. Make changes (fix typos or grammar, improve wording etc).
2. Check to see if older versions need updating too.
3. Send a pull request!

### New Pages and Sections

1. Create new pages and/or sections. Follow the [Conventions](#conventions) below.
2. If you create a new section add an entry for it to the `top_level_sections` list in `_config.yml`. This list determines the order of sections in the navigation sidebar.
3. Add any new sections to the table at the top of this README.
4. Send a pull request!

### Creating a New Version

1. Duplicate the section’s latest version directory and rename it. For example, copy `/server/3.0.0/` to `/server/3.0.1/`.

   > Pre-release documentation should have `-pre` after the version number, e.g. `/server/3.0.1-pre/`. Pre-release documentation will show up on the website but won’t be the default version. In pages’ front matter use `version: "3.0.1 (pre-release)"`.
2. Update front matter in all `.md` files in the new directory to use the new version number.
3. Make edits to files in the new version as appropriate. You may create or delete pages as necessary.
4. Update the version table at the top of this README.
5. Send a pull request!

## Conventions

### File Names

- File and directory names are all lowercase.
- Replace spaces with dashes.
- Markdown files take the `.md` extension.

For example:

```
/dotnet-api/3.0.0/writing-to-a-stream.md
```

For example:

```
http://docs.geteventstore.com/dotnet-api/3.0.0/writing-to-a-stream/index.html
```

### Front Matter

Every page written for Jekyll in markdown has front matter. This is metadata for the page. We specify a title for the page, the section it belongs to, and the version for that section. Title and section should be [title case](http://en.wiktionary.org/wiki/title_case). The version number should be in the format `X.X.X`.

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

The content of our documentation has many authors. These formatting guidelines will help maintain a consistent use of language throughout the docs.

- **Acronyms and abbreviations** should always be set in uppercase (e.g. API, HTTP, JVM)
- **Brand names** should have correct typesetting (e.g. cURL, Event Store, JavaScript, .NET)
- **Example code** should not have a line length of more than 80 characters
