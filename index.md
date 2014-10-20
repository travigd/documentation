---
title: "Documentation"
layout: docs
---

Documentation is still a work-in-progress, and pull requests are accepted gratefully! Currently our blog has a lot more information on features which are not yet well documented here - a list of posts is below.

Binaries for the open source version, and information on the commercial versions (which add management and monitoring tools as well as commercial support) are available at the Event Store website ([http://www.geteventstore.com](http://www.geteventstore.com)). If you have a commercial support contract, please raise support issues via ZenDesk. Our discussion forum is hosted on [Google Groups](https://groups.google.com/forum/?fromgroups#!forum/event-store).

The latest build of the .NET Client API is available as a package named [EventStore.Client](http://nuget.org/packages/EventStore.Client) on NuGet. This is often more up-to-date than the version bundled with the server (which things like the test client utility use). *Note: the Event Store server is versioned separately from the .NET Client API (and any others)*.

*PLEASE NOTE: User projections are not enabled by default, however the projections engine is used internally for account management. If you want to run user projections, it is necessary to start using the `--run-projections=all` command line parameter (or equivalent as per the [command line options](wiki/Command-Line-Arguments) page).*

##Contents

###Getting Started

- [Getting Started with the Atom HTTP API]({{ site.url }}/getting-started)
- [Getting Started on Amazon EC2](http://ges-stuff.tumblr.com/post/50099154651/a-ges-quickstart-amazon-ami)
- [Deploy with puppet]({{ site.url }}/deploy-with-puppet)

###Introduction

- [Event Sourcing Basics](wiki/Event-Sourcing-Basics)
- [Running the Event Store](wiki/Running-the-Event-Store)
	- [Windows / .NET](wiki/Running-the-Event-Store#on-windows-and-net)
	- [Linux / Mono](wiki/Running-the-Event-Store#on-linux-and-mono)
	- [Command Line Options](wiki/Command-Line-Arguments)
	- [Clustering (Open Source)](wiki/Setting-up-an-OSS-cluster)
	- [Database Backup](wiki/Database-Backup)
- [Internal Architectural Overview](wiki/Architectural-Overview)
- [Reliability](wiki/Reliability)

###Cross-API Concepts

- [Reserved Names](wiki/Reserved-Names)
- [Optimistic Concurrency & Idempotence](wiki/Optimistic-Concurrency-&-Idempotence)
- [Client Error Handling](wiki/Client-Error-Handling)
- [Which API to Use?] (wiki/Which-API)
- [Stream Metadata] (wiki/Stream-Metadata-Parameters)
- [Config Options] (wiki/Command-Line-Arguments)
- [Access Control Lists](wiki/Access-Control-Lists)

###HTTP API

- [Overview](wiki/HTTP-Overview)
- [Creating a stream](wiki/Creating-a-Stream-%28HTTP%29)
- [Writing to a stream](wiki/Writing-to-a-Stream-%28HTTP%29)
- [Reading streams] (wiki/Reading-Streams-%28HTTP%29)
- [Deleting a stream](wiki/Deleting-a-Stream-%28HTTP%29)
- [Stream Metadata](wiki/Stream-Metadata-%28HTTP%29)
- [Optional HTTP Headers] (wiki/Optional-Http-Headers)
- [Setup] (wiki/Architecture-Setup%28HTTP%29)
- [Security] (wiki/HTTP-Security)
- [Setting up SSL in Linux] (wiki/Setting-Up-SSL-In-Linux)
- [Setting up SSL in Windows] (wiki/Setting-Up-SSL-In-Windows)
- [Setting up Varnish in Linux] (wiki/Setting-Up-Varnish-In-Linux)

###.NET API

- [Overview](wiki/Overview-%28.NET-API%29)
- [Connection Options](wiki/Connection-Options-%28.NET-API%29)
- [Writing to a stream](wiki/Writing-Events-%28.NET-API%29)
- [Reading streams](wiki/Reading-Streams-%28.NET-API%29)
- [Subscriptions](wiki/Subscriptions-%28.NET-API%29)
- Implementing a repository

###Projections

*Note: Projections are still experimental and as such we have not yet documented them here. However, there are two series of blog posts about how they can be used, which are listed below under the Related Blog Posts section below.*

###Miscellaneous

- Implementing a Client API

##Related Blog Posts

The following blog posts talk about the Event Store and may be useful for features that aren't yet documented here. If you know of any others, please let us know!

###Event Store Blog - Getting Started Series

- [Part 1 - Introduction](http://geteventstore.com/blog/20130220/getting-started-part-1-introduction/)
- [Part 2 - Implementing the CommonDomain repository interface](http://geteventstore.com/blog/20130220/getting-started-part-2-implementing-the-commondomain-repository-interface/)
- [Part 3 - Subscriptions](http://geteventstore.com/blog/20130306/getting-started-part-3-subscriptions/)

###Event Store Blog - Projections Series

- [Part 1 - Projections Theory](http://geteventstore.com/blog/20130212/projections-1-theory/)
- [Part 2 - A Simple SEP Projection](http://geteventstore.com/blog/20130213/projections-2-a-simple-sep-projection/)
- [Part 3 - Using State](http://geteventstore.com/blog/20130215/projections-3-using-state/)
- [Intermission - A Case Study](http://geteventstore.com/blog/20130217/projections-intermission/)
- [Part 4 - Event Matching](http://geteventstore.com/blog/20130218/projections-4-event-matching/)
- [Part 5 - Indexing](http://geteventstore.com/blog/20130218/projections-5-indexing/)
- [Part 6 - An Indexing Use Case](http://geteventstore.com/blog/20130227/projections-6-an-indexing-use-case/)
- [Part 7 - Multiple Streams](http://geteventstore.com/blog/20130309/projections-7-multiple-streams/)
- [Part 8 - Internal Indexing](http://geteventstore.com/blog/20130309/projections-8-internal-indexing/)

###Rob Ashton - Projections Series

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

There is also a [video of Greg Young's "In The Brain" session](http://skillsmatter.com/podcast/design-architecture/event-store-as-a-read-model) recorded at SkillsMatter in London about using projections for Complex Event Processing.

###Other Posts

- [Ensuring Writes](http://geteventstore.com/blog/20130301/ensuring-writes-multi-node-replication/) - describes how writing works in our commercial highly available product.
- [The Cost of Creating a Stream](http://geteventstore.com/blog/20130210/the-cost-of-creating-a-stream/)
- [Various Hash Implementations (BSD Licensed!)](http://geteventstore.com/blog/20120921/a-useful-piece-of-code-1/)

![Google analytics pixel](https://gaproxy-1.apphb.com/UA-40176181-1/Wiki/Home/)