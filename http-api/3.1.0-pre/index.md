---
title: "Overview"
section: "HTTP API"
version: 3.1.0-pre
pinned: true
---

The Event Store provides a native interface of AtomPub over HTTP.

<span class="note">
Examples in this section make use of the command line tool
[cURL](http://curl.haxx.se/) to construct HTTP requests. We use this tool
regularly in development and likely you will find it quite useful as well when
working with the HTTP API.
</span>

## Rationale

The reason the AtomPub API exists is to provide a straightforward way to
interact with the Event Store to any environment capable of making HTTP
requests. It also gives the advantage that it becomes easy to use the Event
Store in heterogenous environments, with components in several different
runtimes (for example, you can imagine having SmallTalk, C# and Haskell access
streams of events in order to allow use cases to be implemented in a style best
suited to them). It also opens up the possibility of using the Event Store as a
queuing system.

AtomPub is a RESTful protocol that can reuse many existing components, for example Reverse Proxies and client’s native HTTP caching. Since events stored in the Event Store are entirely immutable, cache expiration can be infinite. We can also leverage content type negotiation. Appropriately serialized events can be accessed as JSON or XML according to the request headers.

This all leads to an interesting scenario where, although at first glance HTTP would seem to be less efficient as a protocol than the native TCP API, it is in many cases actually more efficient after intermediary caching is brought into play. As an example, replaying a stream is a very common operation. This operation using HTTP will likely make only a single call to the Event Store (a head read) with the rest of the GETs being resolved from the local or intermediary cache.

## Factors affecting choice of API

Although there are a number of advantages to using the AtomPub API, there are also some disadvantages.

If you discount intermediate caching the protocol is more expensive than the TCP protocol. On a reasonably specified machine, the Event Store can service about 2,000 requests per second as AtomPub over HTTP (an order of magnitude lower than can be serviced over TCP).

There is also a latency increase when using AtomPub, as a component wishing to subscribe would poll for new events rather than having new events pushed to it as can be the case with the TCP API. The latency on a subscribe operation is generally measure in a few ms where as the latency for delivery to a poller will be measured in seconds.

## Compatibility with AtomPub

The Event Store is fully compatible with the 1.0 version of the Atom Protocol. If problems are found the protocol specified behaviour will be followed in future releases. There are however extensions to the protocol that have been made such as headers for control and some custom `rel` links.

### Content Types

The preferred way of determining with which content type responses will be served is to set the Accept header on the request. However, as some clients do not deal well with HTTP headers when caching, appending a format parameter to the URL is also supported.

The accepted content types for POST requests are currently:

- `application/xml`
- `application/json`
- `text/xml`

In addition to those, these content types are also accepted for GET requests:

- `application/atom+xml`
- `application/vnd.eventstore.atom+json` 
- `text/html`

There will likely be additions in the future for protobufs and bson.

As an example you can either use `content-type` or you can use a `?format=xml` in the URL to decide the format type that you receive. This is due to some clients not dealing well with HTTP headers, it can also be useful with some caching systems as the URLs then are unique. This applies to all URLs used within the AtomPub system including `/event/{id}` links. The general prefered mechanism however is for you to set [Accept Headers] in your http request. All HTTP-based interactions with the Event Store support multiple formats. As of time of the writing the accepted content types for streams are `application/atom+xml`, `application/vnd.eventstore.atom+json`, `application/xml`, `application/json`, and `text`. This pattern is followed for atomsvc and atomcat as well. If you were to post with an accept of `application/atom+xml` then your repsonse will be `application/atom+xml`, if you did the same post with `application/xml` you will get back the atom feed in an XML format but without the `atom+xml` content type.

For example:

```
ouro@ouroboros:~$ curl -i -H "Accept:application/atom+xml" "http://127.0.0.1:2113/streams/anewstream"
```

```http
HTTP/1.1 200 OK
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: POST, GET, PUT, DELETE
Content-Type: application/atom+xml
Server: Mono-HTTPAPI/1.0
Date: Sat, 08 Sep 2012 11:14:52 GMT
Content-Length: 1743
Keep-Alive: timeout=15,max=100
```

```xml
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
  <title>Event stream 'anewstream'</title>
  <id>http://127.0.0.1:2113/streams/anewstream</id>
  <updated>2012-09-08T08:14:08.348643Z</updated>
  <author>
    <name>EventStore</name>
  </author>
  <link href="http://127.0.0.1:2113/streams/anewstream" rel="self" />
  <link href="http://127.0.0.1:2113/streams/anewstream" rel="first" />
  <link href="http://127.0.0.1:2113/streams/anewstream/range/0/20" rel="prev" />
  <link href="http://127.0.0.1:2113/streams/anewstream/range/20/20" rel="next" />
  <entry>
    <title>anewstream #1</title>
    <id>http://127.0.0.1:2113/streams/anewstream/1</id>
    <updated>2012-09-08T08:14:08.348643Z</updated>
    <author>
      <name>EventStore</name>
    </author>
    <summary>Entry #1</summary>
    <link href="http://127.0.0.1:2113/streams/anewstream/1" rel="edit" />
    <link href="http://127.0.0.1:2113/streams/anewstream/event/1?format=text" type="text/plain" />
    <link href="http://127.0.0.1:2113/streams/anewstream/event/1?format=json" rel="alternate" type="application/json" />
    <link href="http://127.0.0.1:2113/streams/anewstream/event/1?format=xml" rel="alternate" type="text/xml" />
  </entry>
  <entry>
    <title>anewstream #0</title>
    <id>http://127.0.0.1:2113/streams/anewstream/0</id>
    <updated>2012-09-08T08:14:08.345651Z</updated>
    <author>
      <name>EventStore</name>
    </author>
    <summary>Entry #0</summary>
    <link href="http://127.0.0.1:2113/streams/anewstream/0" rel="edit" />
    <link href="http://127.0.0.1:2113/streams/anewstream/event/0?format=text" type="text/plain" />
    <link href="http://127.0.0.1:2113/streams/anewstream/event/0?format=json" rel="alternate" type="application/json" />
    <link href="http://127.0.0.1:2113/streams/anewstream/event/0?format=xml" rel="alternate" type="text/xml" />
  </entry>
</feed>
```

or

```
greg@ouroboros:~/src/EventStore.wiki$ curl -i -H "Accept:text/xml" "http://127.0.0.1:2113/streams/newstream"
```

```http
HTTP/1.1 200 OK
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER
Access-Control-Allow-Origin: *
Cache-Control: max-age=0, no-cache, must-revalidate
Vary: Accept
ETag: "1;-1004727243"
Content-Type: text/xml; charset: utf-8
Server: Mono-HTTPAPI/1.0
Date: Fri, 28 Jun 2013 16:29:42 GMT
Content-Length: 1345
Keep-Alive: timeout=15,max=100
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
   <title>Event stream 'newstream'</title>
   <id>http://127.0.0.1:2113/streams/newstream</id>
   <updated>2013-06-28T09:32:18.546342Z</updated>
   <author>
      <name>EventStore</name>
   </author>
   <link href="http://127.0.0.1:2113/streams/newstream" rel="self" />
   <link href="http://127.0.0.1:2113/streams/newstream/head/backward/20" rel="first" />
   <link href="http://127.0.0.1:2113/streams/newstream/0/forward/20" rel="last" />
   <link href="http://127.0.0.1:2113/streams/newstream/2/forward/20" rel="previous" />
   <link href="http://127.0.0.1:2113/streams/newstream/metadata" rel="metadata" />
   <entry>
      <title>1@newstream</title>
      <id>http://127.0.0.1:2113/streams/newstream/1</id>
      <updated>2013-06-28T09:32:18.546342Z</updated>
      <author>
         <name>EventStore</name>
      </author>
      <summary>event-type</summary>
      <link href="http://127.0.0.1:2113/streams/newstream/1" rel="edit" />
      <link href="http://127.0.0.1:2113/streams/newstream/1" rel="alternate" />
   </entry>
   <entry>
      <title>0@newstream</title>
      <id>http://127.0.0.1:2113/streams/newstream/0</id>
      <updated>2013-06-28T09:17:59.666655Z</updated>
      <author>
         <name>EventStore</name>
      </author>
      <summary>event-type</summary>
      <link href="http://127.0.0.1:2113/streams/newstream/0" rel="edit" />
      <link href="http://127.0.0.1:2113/streams/newstream/0" rel="alternate" />
   </entry>
</feed>
```

The same feed could also be acquired as `application/vnd.eventstore.atom+json` or `application/json` depending on accept headers given.

```
ouro@ouroboros:~/src/EventStore.wiki$ curl -i "http://127.0.0.1:2113/streams/newstream" -H "Content-Type:application/json" -u admin:changeit
```

```http

HTTP/1.1 200 OK
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER
Access-Control-Allow-Origin: *
Cache-Control: max-age=0, no-cache, must-revalidate
Vary: Accept
ETag: "1;248368668"
Content-Type: application/vnd.eventstore.atom+json; charset: utf-8
Server: Mono-HTTPAPI/1.0
Date: Fri, 28 Jun 2013 15:45:19 GMT
Content-Length: 1750
Keep-Alive: timeout=15,max=100
```

```json
{
  "title": "Event stream 'newstream'",
  "id": "http://127.0.0.1:2113/streams/newstream",
  "updated": "2013-06-28T09:32:18.546342Z",
  "streamId": "newstream",
  "author": {
    "name": "EventStore"
  },
  "links": [
    {
      "uri": "http://127.0.0.1:2113/streams/newstream",
      "relation": "self"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/newstream/head/backward/20",
      "relation": "first"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/newstream/0/forward/20",
      "relation": "last"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/newstream/2/forward/20",
      "relation": "previous"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/newstream/metadata",
      "relation": "metadata"
    }
  ],
  "entries": [
    {
      "title": "1@newstream",
      "id": "http://127.0.0.1:2113/streams/newstream/1",
      "updated": "2013-06-28T09:32:18.546342Z",
      "author": {
        "name": "EventStore"
      },
      "summary": "event-type",
      "links": [
        {
          "uri": "http://127.0.0.1:2113/streams/newstream/1",
          "relation": "edit"
        },
        {
          "uri": "http://127.0.0.1:2113/streams/newstream/1",
          "relation": "alternate"
        }
      ]
    },
    {
      "title": "0@newstream",
      "id": "http://127.0.0.1:2113/streams/newstream/0",
      "updated": "2013-06-28T09:17:59.666655Z",
      "author": {
        "name": "EventStore"
      },
      "summary": "event-type",
      "links": [
        {
          "uri": "http://127.0.0.1:2113/streams/newstream/0",
          "relation": "edit"
        },
        {
          "uri": "http://127.0.0.1:2113/streams/newstream/0",
          "relation": "alternate"
        }
      ]
    }
  ]
}
```

Going along with this when posting content it listens to what you said it is. If for example you were to post new content with `accept: json` or `?format=json` you must put your content in that format or else you will get an error. Consider the following:

### simple-event.txt:

```json
{
    "CorrelationId" : "0f7fac5b-d9cb-469f-a167-70867728950e",
    "ExpectedVersion" : "-1",
    "Events" : [
            {
                "EventId" : "0f9fad5b-d9cb-469f-a165-70867728951e",
                "EventType" : "Type",
                "Data" : { "Foo" : "Bar" },
                "Metadata" : { "Something" : "AValue"}
            }
           ]
}
```

```
greg@ouroboros:~$ curl -i -d @simple-event.txt "http://127.0.0.1:2113/streams/newstream" -H "Content-Type:text/xml"
```

```http
HTTP/1.1 400 Write request body cannot be deserialized
Access-Control-Allow-Methods: DELETE, GET, POST
Server: Mono-HTTPAPI/1.0
Date: Thu, 13 Sep 2012 08:41:45 GMT
Content-Length: 0
Connection: close
```

I will get an error if I try to post this as XML. I can however post it as JSON.

```
ouro@ouroboros:~$ curl -i -d @/home/ouro/Downloads/simpleevent.txt "http://127.0.0.1:2113/streams/newstream" -H "Content-Type:application/json"
```

```http
HTTP/1.1 201 Created
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: POST, GET, PUT, DELETE
Location: http://127.0.0.1:2113/streams/newstream/1
Content-Type: application/json
Server: Mono-HTTPAPI/1.0
Date: Wed, 12 Sep 2012 11:26:28 GMT
Content-Length: 0
Keep-Alive: timeout=15,max=100
```

When dealing with retreiving an event from a stream you can also ask for it in either XML or JSON (internally it will be converted for you). As we saw in the above example the event was pushed in JSON. It can be requested as XML or as JSON.

<span class="note">
You should not in general be bookmarking these links. They come from the atomfeed where you can also select the media type that you want.
</span>

```
ouro@ouroboros:~/src/EventStoreDocs$ curl -i http://127.0.0.1:2113/streams/newstream/event/1?format=xml
```

or

```
ouro@ouroboros:~/src/EventStoreDocs$ curl -i http://127.0.0.1:2113/streams/newstream/event/1 -H "Accept: text/xml"
```

```http
HTTP/1.1 200 OK
Access-Control-Allow-Methods: GET
Content-Type: text/xml
Server: Mono-HTTPAPI/1.0
Date: Thu, 13 Sep 2012 10:55:13 GMT
Content-Length: 312
Keep-Alive: timeout=15,max=100
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ReadEventCompletedText>
   <correlationId>680fccc2-3c6c-4ed0-ad8a-b952bd446873</correlationId>
   <eventStreamId>newstream</eventStreamId>
   <eventNumber>1</eventNumber>
   <eventType>Type</eventType>
   <data>
       <Foo>Bar</Foo>
   </data>
   <metadata>
      <Foo>Bar</Foo>
   </metadata>
</ReadEventCompletedText>
```

and as JSON

```
ouro@ouroboros:~/src/EventStoreDocs$ curl -i http://127.0.0.1:2113/streams/newstream/event/1 -H "Accept: application/json"
```

```http
ouro@ouroboros:~/src/EventStoreDocs$ curl -i http://127.0.0.1:2113/streams/newstream/event/1?format=json
HTTP/1.1 200 OK
Access-Control-Allow-Methods: GET
Content-Type: application/json
Server: Mono-HTTPAPI/1.0
Date: Thu, 13 Sep 2012 10:57:26 GMT
Content-Length: 208
Keep-Alive: timeout=15,max=100
```

```json
{
  "correlationId": "ed4bbdc6-c7ce-449e-bbda-0d903b1c82c3",
  "eventStreamId": "newstream",
  "eventNumber": 1,
  "eventType": "Type",
  "data": {
    "Foo": "Bar"
  },
  "metadata": {
    "Foo": "Bar"
  }
}
```

### Batching

It is possible to post multiple items into a stream using a single request. Events posted in the same request are treated transactionally. The way to do this is to provide multiple entries for `events/metadata`. It is assumed that all events should be written in the order they are given.

```json
[
  {
    "eventId": "fbf4b1a1-b4a3-4dfe-a01f-ec52c34e16e4",
    "eventType": "event-type",
    "data": {

      "a": "1"
    }
  },
  {
    "eventId": "0f9fad5b-d9cb-469f-a165-70867728951e",
    "eventType": "event-type",
    "data": {

      "a": "1"
    }
  }
]
```

```xml
<Events>
    <Event>
         <EventId>fbf4a1a1-b4a3-4dfe-a01f-ec52c34e16e4</EventId>
         <EventType>event-type</EventType>
         <Data>
           <MyEvent>
                    <Something>1</Something>
               </MyEvent>
         </Data>
    </Event>
    <Event>
         <EventId>0f9fad5b-d9cb-469f-a165-70867728951e</EventId>
         <EventType>event-type2</EventType>
         <Data>
           <MyEvent>
                    <SomethingElse>1</SomethingElse>
               </MyEvent>
         </Data>
    </Event>

</Events>
```

```
ouro@ouroboros:~$ curl -i -d @/home/greg/Downloads/simpleevent.txt "http://127.0.0.1:2113/streams/newstream" -H "Content-Type:application/json"
```

```http
HTTP/1.1 201 Created
Access-Control-Allow-Methods: DELETE, GET, POST, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER
Access-Control-Allow-Origin: *
Location: http://127.0.0.1:2113/streams/newstream/2
Content-Type: ; charset: utf-8
Server: Mono-HTTPAPI/1.0
Date: Wed, 03 Apr 2013 15:21:53 GMT
Content-Length: 0
Keep-Alive: timeout=15,max=100
```