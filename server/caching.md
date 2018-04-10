---
outputFileName: index.html
---

# Caching

As there are large differences between running Event Store in development and production, it's important to understand how caching works.

Most of the URIs that Event Store emits are immutable (including the UI, Atom Feeds, etc). You can see an example of this in an Atom feed.

An Atom feed has a URI that represents an event, e.g. `/streams/foo/0`, representing 'event 0'. The data for event 0 will never change. If this stream is open to public reads then the URI will be set to be 'cachable' for long periods of time. You can see a similar example in reading a feed, if a stream has 50 events in it the feed page `20/forward/10` will never change, it will always be events 20-30. Internally Event Store controls serving the right URIs by using `rel` links with feeds (for example `prev`/`next`).

This caching behaviour is great for performance in a production environment and is highly recommended. In a developer environment it can be confusing. For example, what would happen if you started a database, wrote `/streams/foo/0` and performed a `GET` request. This `GET` request is cachable and now in your cache. Since this is a development environment, you shutdown and delete the database. You then restart it and write a different event to `/streams/foo/0`. You open your browser and inspect the `/streams/foo/0` stream, and you will see the event written before you deleted the database.

To avoid this it's best to run Event Store with the `--disable-http-caching` command line option. This will disable all caching and solve the issue.
