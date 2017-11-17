---
title: "Which API to Use?"
section: "Introduction"
version: "4.0.2"
---

There are multiple interfaces over which you can communicate with Event Store. This document describes them briefly and with the aim of helping you choose which one suits your use case.

## TCP

A low level protocol is offered in the form of an asynchronous TCP protocol that exchanges protobuf objects. At present this protocol has adapters for .NET and Node.js, though more adapters are in progress for other platforms including the JVM.

### Supported Clients

-   [.net Client](http://www.nuget.org/packages/EventStore.Client)
-   [JVM Client](https://github.com/EventStore/EventStore.JVM)

### Community Developed Clients

-   [Node.js](https://www.npmjs.com/package/event-store-client)
-   [Node.js](https://www.npmjs.com/package/ges-client)
-   [Node.js](https://github.com/nicdex/eventstore-node)
-   [Haskell](https://github.com/YoEight/eventstore)
-   [Erlang](https://bitbucket.org/anakryiko/erles)
-   [F#](https://github.com/haf/EventStore.Client.FSharp)
-   [PHP](https://github.com/dbellettini/php-eventstore-client)
-   [Elixir](https://github.com/exponentially/extreme)
-   [Python](https://github.com/madedotcom/atomicpuppy)
-   [Java8](https://github.com/msemys/esjc)
-   [Maven plugin](https://github.com/fuinorg/event-store-maven-plugin)

## HTTP

The other interface is HTTP-based, more specifically based upon the [AtomPub protocol](http://tools.ietf.org/html/rfc5023). As it operates over HTTP this will be seemingly less efficient, but nearly any environment supports it.

### Supported Clients

-   [HTTP API](/http-api)

### Community Developed Clients

-   [Ruby](https://github.com/arkency/http_eventstore)
-   [Go](https://github.com/jetbasrawi/go.geteventstore)

<span class="note">
<!-- How? -->
Feel free to add more! Being listed as a community client does not imply official support.
</span>

## Which to use?

There are many factors that go into the choice of which of the protocols (TCP vs HTTP) to use. Both have their strengths and weaknesses.

### TCP is faster

This especially applies to subscribers as events will be pushed to the subscriber, whereas with Atom the subscribers will poll the head of the atom feed to check if new events are available. The difference can be as high as 2–3 times higher (sub 10ms for TCP, vs seconds for Atom).

Also, the number of writes per second supported is often dramatically higher when using TCP. At the time of writing, standard Event Store appliances can service around 2000 writes/second over HTTP compared to 15,000-20,000/second over TCP. This might be a deciding factor if you are in a high-performance environment.

### AtomPub is more scalable for large numbers of subscribers.

This is due to the ability to use intermediary caching with Atom feeds. Most URIs returned by Event Store point to immutable data and are therefore infinitely cachable. Therefore on a replay of a projection much of the data required is likely to be available on a local or intermediary cache. This can also lead to lower network traffic.

Atom tend to operate better in a large heterogenous environment where you have callers from many different platforms. This is especially true if you have to integrate with different teams or external vendors. Atom is an industry standard and well documented protocol that you can point whereas the TCP protocol is a custom protocol they would need to understand.

Most platforms have good existing tooling for Atom including feed readers (e.g. Fiddler). None of this tooling exists for analyzing traffic with the TCP protocol.

<span class="note">
Our recommendation would be to use AtomPub as your primary protocol unless you have low subscriber SLAs or need higher throughput on reads and writes than Atom can offer. This is due to the open nature and ease of use of the Atom protocol. Often in integration scenarios these are more important than raw performance.
</span>
