# Event Store Documentation

**This documentation is available at [https://eventstore.org/docs](https://eventstore.org/docs).** Pages are built with [DocFX](https://dotnet.github.io).

What follows is documentation for how to use and contribute to the Event Store documentation. If you’re planning to make updates or contributions then read on. Otherwise, head on over to the [website](https://eventstore.org/docs).

## Contributing to Event Store Documentation

Event Store consists of different components, and the documentation reflects this. Depending on what you want to contribute to, the process is different.

### Conceptual Documentation

This is the bulk of documentation, and where you mostly likely want to contribute to. It uses 'DocFX flavored Markdown'. It is similar to standard or GitHub Flavored Markdown, but adds features useful for documentation you can find details of [here](#).

### API Spec
<!-- TODO: Open API spec blah -->
In additions to conceptual docs on the HTTP API, the documentation includes a [swagger spec file](#) that [DocFX renders to HTML](#) when building the site. Any contributions to that file are welcome, read the [Swagger xxx](#) for more details on the format of that file.

### Code Documentation
When DocFX builds the documentation site it parses xxx code comments and renders them as HTML. If you want to contribute to that documentation, then find instructions in the [code base reposity](#).

### Documentation Theme
Finally, if you would like to improve the theme for the documentation site, then you can find its repository [here](#).
---

## Versioning

The Event Store documentation is available for many versions of Event Store and its APIs. By default the website shows documentation for the latest stable release of each component. Current sections and versions are:

| Section      | Versions                                                        |
| :----------- | :-------------------------------------------------------------- |
| Introduction | Always shows latest                                             |
| Server       | 4.0.0 (latest), 3.3.0, 3.2.0, 3.1.0, 3.0.5, 3.0.3, 3.0.2, 3.0.1, 3.0.0 |
| .NET API     | 4.0.0 (latest), 3.2.0, 3.1.0, 3.0.2, 3.0.1, 3.0.0                      |
| HTTP API     | 4.0.0 (latest), 3.2.0, 3.1.0, 3.0.3, 3.0.2, 3.0.1, 3.0.0               |
| Projections  | 4.0.0 (latest) |

The Event Store server uses [semantic versioning](http://semver.org). API versions are based on the major server version they support.


### Running DocFX Locally

You can generate the site locally and test your changes. Follow the instructions [here](#) to install DocFX and dependencies.

<!-- TODO: Why is there a subpath and how does it relate? -->
The compiled site builds into `/docs` and is hosted at `http://localhost:8080/docs`.

### Small Edits

1. Make changes (fix typos or grammar, improve wording etc).
2. Check to see if older versions need updating too.
3. Send a pull request!

### New Pages and Sections

1. Create new pages and/or sections. Follow the [Conventions](#conventions) below.
2. If you create a new section add an entry for it to the *toc.md* file. This file determines the order of sections in the navigation sidebar.
3. Send a pull request!

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
http://https://eventstore.org/docs/dotnet-api/3.0.0/writing-to-a-stream/index.html
```

### Formatting and Typesetting

The content of our documentation has multiple authors. Formatting and style guidelines help maintain a consistent use of language throughout the docs.

- **Acronyms and abbreviations**: Use uppercase (e.g. API, HTTP, JVM)
- **Brand names**: Use correct typesetting (e.g. cURL, Event Store, JavaScript, .NET)
- **Example code** should not have a line length of more than 80 characters
