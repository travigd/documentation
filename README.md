# Event Store Documentation

**This documentation is available at <https://eventstore.org/docs>.** Pages are built with [DocFX](https://dotnet.github.io).

What follows is documentation for how to use and contribute to the Event Store documentation. If you’re planning to make updates or contributions then read on. Otherwise, head on over to the [website](https://eventstore.org/docs).

## Contributing to Event Store Documentation

The Event Store documentation consists of different components, and the documentation reflects this. Depending on what you want to contribute to, the process is different.

### Conceptual Documentation

This is the bulk of documentation, and where you mostly likely want to contribute. It uses 'DocFX flavored Markdown'. It is similar to standard or GitHub Flavored Markdown, but adds features useful for documentation you can find details of [here](https://dotnet.github.io/docfx/spec/docfx_flavored_markdown.html?tabs=tabid-2%2Ctabid-b).

### HTTP API Spec

In additions to conceptual docs on the HTTP API, the documentation includes an [OpenAPI spec file](https://github.com/EventStore/docs.geteventstore.com/blob/master/http-api/swagger.yaml) that [DocFX renders to HTML](https://dotnet.github.io/docfx/tutorial/intro_rest_api_documentation.html) when building the site. Any contributions to that file are welcome, read the [OpenAPI spec](https://swagger.io/docs/specification/about/) for more details on the format of that file.

### Code Documentation

When DocFX builds the documentation it parses [XML code comments](https://docs.microsoft.com/en-us/dotnet/csharp/codedoc) and renders them as HTML. If you want to contribute to that documentation, then find instructions in the [code base repository](https://github.com/EventStore/EventStore).

### Documentation Theme

Finally, if you would like to improve the theme for the documentation site, then you can find its repository [here](https://github.com/EventStore/es-docs-template).

### Running DocFX Locally

You can generate the site locally and test your changes. Follow the instructions [here](https://dotnet.github.io/docfx/tutorial/docfx_getting_started.html) to install DocFX and dependencies, then run:

```bash
docfx build docfx.json --serve
```

This builds the site to the `/_site` folder and serves it at `http://localhost:8080`.

### Small Edits

1.  Make changes (fix typos or grammar, improve wording etc).
2.  Send a pull request!

### New Pages and Sections

1.  Create new pages and/or sections. Follow the [Conventions](#conventions) below.
2.  If you create a new section add an entry for it to the _toc.md_ file. This file determines the order of sections in the navigation sidebar and helps DocFX build internal navigation.
3.  Send a pull request!

## Conventions

### File Names

-   File and directory names are all lowercase.
-   Replace spaces with dashes.
-   Markdown files take the `.md` extension.

### Formatting and Typesetting

The content of our documentation has multiple authors. Formatting and style guidelines help maintain a consistent use of language throughout the docs.

-   **Acronyms and abbreviations**: Use uppercase (e.g. API, HTTP, JVM)
-   **Brand names**: Use correct typesetting (e.g. cURL, Event Store, JavaScript, .NET)
-   **Example code** should not have a line length of more than 80 characters
