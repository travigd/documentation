---
title: "Documentation"
layout: docs
---

<p class="docs-lead">Event Store docs are hosted on GitHub. The repository is public, and <a href="https://github.com/eventstore/docs.geteventstore.com">it’s open to pull requests</a>. We’ve got a bunch of goodies, beer tokens and more ready to send out to people who contribute.</p>

## Using These Docs

The documentation is split into sections that can be independently versioned. The section version correlates to the version of software is applies to. Use the sidebar navigation to browse docs for the section and version you are interested in.

If you want to share a link to the documentation, you can either use a version-specific URL or a “latest” URL. For example:

- `http://docs.geteventstore.com/server/3.0.0/command-line-arguments/` for version 3.0.0
- `http://docs.geteventstore.com/server/latest/command-line-arguments/` for the latest version

is 

## Projections

User projections are not enabled by default, however the projections engine is used internally for account management. If you want to run user projections, it is necessary to start using the `--run-projections=all` command line parameter (or equivalent as per the [command line arguments]({{ site.url }}/server/latest/command-line-arguments) page).

Projections are still experimental and as such we have not yet documented them here. However, there are two series of blog posts about how they can be used, which are listed below under the Related Blog Posts section below.

## Related Blog Posts

The following blog posts talk about the Event Store and may be useful for features that aren’t yet documented here. If you know of any others, please let us know!

### Getting Started Series

- [Part 1 - Introduction](http://geteventstore.com/blog/20130220/getting-started-part-1-introduction/)
- [Part 2 - Implementing the CommonDomain repository interface](http://geteventstore.com/blog/20130220/getting-started-part-2-implementing-the-commondomain-repository-interface/)
- [Part 3 - Subscriptions](http://geteventstore.com/blog/20130306/getting-started-part-3-subscriptions/)

### Projections Series

- [Part 1 - Projections Theory](http://geteventstore.com/blog/20130212/projections-1-theory/)
- [Part 2 - A Simple SEP Projection](http://geteventstore.com/blog/20130213/projections-2-a-simple-sep-projection/)
- [Part 3 - Using State](http://geteventstore.com/blog/20130215/projections-3-using-state/)
- [Intermission - A Case Study](http://geteventstore.com/blog/20130217/projections-intermission/)
- [Part 4 - Event Matching](http://geteventstore.com/blog/20130218/projections-4-event-matching/)
- [Part 5 - Indexing](http://geteventstore.com/blog/20130218/projections-5-indexing/)
- [Part 6 - An Indexing Use Case](http://geteventstore.com/blog/20130227/projections-6-an-indexing-use-case/)
- [Part 7 - Multiple Streams](http://geteventstore.com/blog/20130309/projections-7-multiple-streams/)
- [Part 8 - Internal Indexing](http://geteventstore.com/blog/20130309/projections-8-internal-indexing/)

### Rob Ashton’s Projections Series

- [Part 1 - Introduction to the EventStore](http://codeofrob.com/entries/playing-with-the-eventstore.html)
- [Part 2 - Pushing data into the EventStore](http://codeofrob.com/entries/pushing-data-into-streams-in-the-eventstore.html)
- [Part 3 - Projections in the EventStore](http://codeofrob.com/entries/basic-projections-in-the-eventstore.html)
- [Part 4 - Re-partitioning streams in the EventStore](http://codeofrob.com/entries/re-partitioning-streams-in-the-event-store-for-better-projections.html)
- [Part 5 - Creating a projection per stream](http://codeofrob.com/entries/creating-a-projection-per-stream-in-the-eventstore.html)
- [Part 6 - Pumping data from Github into the EventStore](http://codeofrob.com/entries/less-abstract,-pumping-data-from-github-into-the-eventstore.html)
- [Part 7 - Emitting new events from a projection](http://codeofrob.com/entries/evented-github-adventure---emitting-commits-as-their-own-events.html)
- [Part 8 - Who is the sweariest of them all?](http://codeofrob.com/entries/evented-github-adventure---who-writes-the-sweariest-commit-messages.html)
- [Part 9 - Temporal queries in the event store](http://codeofrob.com/entries/evented-github-adventure---temporal-queries,-who-doesnt-trust-their-hardware.html)
- [Part 10 - Projections from multiple streams](http://codeofrob.com/entries/evented-github-adventure---crossing-the-streams-to-gain-real-insights.html)
- [Part 11 - Temporal averages](http://codeofrob.com/entries/evented-github-adventure---temporal-averages.html)
- [Part 12 - (Aside) Database storage and backing up](http://codeofrob.com/entries/evented-github-adventure---database-storage-and-backing-up.html)
- [Part 13 - Sentiment analysis of github commits](http://codeofrob.com/entries/evented-github-adventure---sentiment-analysis-of-github-commits.html)

There is also a [video of Greg Young’s “In The Brain” session](http://skillsmatter.com/podcast/design-architecture/event-store-as-a-read-model) recorded at SkillsMatter in London about using projections for Complex Event Processing.

### Other Posts

- [Ensuring Writes](http://geteventstore.com/blog/20130301/ensuring-writes-multi-node-replication/) - describes how writing works in our commercial highly available product.
- [The Cost of Creating a Stream](http://geteventstore.com/blog/20130210/the-cost-of-creating-a-stream/)
- [Various Hash Implementations (BSD Licensed!)](http://geteventstore.com/blog/20120921/a-useful-piece-of-code-1/)