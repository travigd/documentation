---
title: "Reading Streams and Events"
section: "HTTP API"
version: "4.0.2"
---

Reading from streams with AtomPub can be confusing the first time, but Event Store is compliant with the [Atom 1.0 Specification](http://tools.ietf.org/html/rfc4287) and so many environments have already implemented the AtomPub protocol, and that simplifies the process.

## Existing Implementations

| Library     | Description                                                       |
| ----------- | ----------------------------------------------------------------- |
| NET (BCL)   | `System.ServiceModel.SyndicationServices`                         |
| JVM         | <http://java-source.net/open-source/rss-rdf-tools>                |
| PHP         | <http://simplepie.org/> or <https://github.com/fguillot/picoFeed> |
| Ruby        | <http://simple-rss.rubyforge.org>                                 |
| Clojure     | <https://github.com/scsibug/feedparser-clj>                       |
| Go          | <https://github.com/jteeuwen/go-pkg-rss>                          |
| Python      | <http://code.google.com/p/feedparser/>                            |
| node.js     | <https://github.com/danmactough/node-feedparser>                  |
| Objective-C | <https://geekli.st/darvin/repos/MWFeedParser>                     |

<span class="note--warning">
The above list are not officially supported by Event Store, if you know of any others [then please let us know](https://eventstore.org/contact/).
</span>

## Reading a Stream

Event Store exposes streams as a resource located at _http(s)://{yourdomain.com}:{port}/streams/{stream}_. If you issue a simple `GET` request to this resource you will receive a standard AtomFeed document as a response.

<div class="codetabs" markdown="1">
<div data-lang="request" markdown="1">
```bash
curl -i -H "Accept:application/vnd.eventstore.atom+json" "http://127.0.0.1:2113/streams/newstream"
```
</div>
<div data-lang="response" markdown="1">
```http
HTTP/1.1 200 OK
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER, Authorization, ES-LongPoll, ES-ExpectedVersion, ES-EventId, ES-EventType, ES-RequiresMaster, ES-HardDelete, ES-ResolveLinkTo, ES-ExpectedVersion
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location, ES-Position
Cache-Control: max-age=0, no-cache, must-revalidate
Vary: Accept
ETag: "0;248368668"
Content-Type: application/vnd.eventstore.atom+json; charset=utf-8
Server: Mono-HTTPAPI/1.0
Date: Fri, 13 Mar 2015 12:15:08 GMT
Content-Length: 1272
Keep-Alive: timeout=15,max=100

{
  "title": "Event stream 'newstream'",
  "id": "<http://127.0.0.1:2113/streams/newstream">,
  "updated": "2017-11-09T13:10:16.111657Z",
  "streamId": "newstream",
  "author": {
    "name": "EventStore"
  },
  "headOfStream": true,
  "selfUrl": "<http://127.0.0.1:2113/streams/newstream">,
  "eTag": "1;-2060438500",
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
      "uri": "http://127.0.0.1:2113/streams/newstream/2/forward/20",
      "relation": "previous"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/newstream/metadata",
      "relation": "metadata"
    }
  ],
  "entries": \[
    {
      "title": "1@newstream",
      "id": "<http://127.0.0.1:2113/streams/newstream/1">,
      "updated": "2017-11-09T13:10:16.111657Z",
      "author": {
        "name": "EventStore"
      },
      "summary": "SomeEvent",
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
      "id": "<http://127.0.0.1:2113/streams/newstream/0">,
      "updated": "2017-11-09T12:04:15.494635Z",
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
</div>
</div>

There some important aspects to notice here. The feed has one item in it, if there are more than one, then items are sorted from newest to oldest.

For each entry, there are a series of links to the actual events, embedding data into a stream [is covered later](#embedding-data-into-stream). To get an event, follow the `alternate` link and set your `Accept` headers to the mime type you would like the event in.

The accepted content types for GET requests are:

-   `application/xml`
-   `application/atom+xml`
-   `application/json`
-   `application/vnd.eventstore.atom+json`
-   `text/xml`
-   `text/html`

<div class="codetabs" markdown="1">
<div data-lang="request" markdown="1">
```bash
curl -i http://127.0.0.1:2113/streams/newstream/1 -H "Accept: application/json"
```
</div>
<div data-lang="response" markdown="1">
```http
HTTP/1.1 200 OK
Access-Control-Allow-Methods: GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-Forwarded-Host, X-Forwarded-Prefix, X-PINGOTHER, Authorization, ES-LongPoll, ES-ExpectedVersion, ES-EventId, ES-EventType, ES-RequiresMaster, ES-HardDelete, ES-ResolveLinkTos
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location, ES-Position, ES-CurrentVersion
Cache-Control: max-age=31536000, public
Vary: Accept
Content-Type: application/json; charset=utf-8
Server: Mono-HTTPAPI/1.0
Date: Thu, 09 Nov 2017 13:31:02 GMT
Content-Length: 29
Keep-Alive: timeout=15,max=100

{
"something": "has data"
}
```
</div>
</div>

The atom version of the event contains extra details about the event.

<div class="codetabs" markdown="1">
<div data-lang="request" markdown="1">
```bash
curl -i http://127.0.0.1:2113/streams/newstream/1 -H "Accept: application/vnd.eventstore.atom+json"
```
</div>
<div data-lang="response" markdown="1">
```http
HTTP/1.1 200 OK
Access-Control-Allow-Methods: GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-Forwarded-Host, X-Forwarded-Prefix, X-PINGOTHER, Authorization, ES-LongPoll, ES-ExpectedVersion, ES-EventId, ES-EventType, ES-RequiresMaster, ES-HardDelete, ES-ResolveLinkTos
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location, ES-Position, ES-CurrentVersion
Cache-Control: max-age=31536000, public
Vary: Accept
Content-Type: application/vnd.eventstore.atom+json; charset=utf-8
Server: Mono-HTTPAPI/1.0
Date: Thu, 09 Nov 2017 13:35:43 GMT
Content-Length: 640
Keep-Alive: timeout=15,max=100

{
"title": "1@newstream",
"id": "<http://127.0.0.1:2113/streams/newstream/1">,
"updated": "2017-11-09T13:10:16.111657Z",
"author": {
"name": "EventStore"
},
  "summary": "SomeEvent",
  "content": {
    "eventStreamId": "newstream",
    "eventNumber": 1,
    "eventType": "SomeEvent",
    "eventId": "c322e299-cb73-4b47-97c5-5054f920746e",
    "data": {
      "something": "has data"
    },
    "metadata": ""
  },
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
}
```
</div>
</div>

## Feed Paging

The next step in understanding how to read a stream is the `first`/`last`/`previous`/`next` links within a stream. Event Store supplies these links so you can read through a stream, and they follow the pattern defined in [RFC 5005](http://tools.ietf.org/html/rfc5005).

In the example above the server returned the following `links` as part of its result:

```json
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
    "uri": "http://127.0.0.1:2113/streams/newstream/1/forward/20",
    "relation": "previous"
  },
  {
    "uri": "http://127.0.0.1:2113/streams/newstream/metadata",
    "relation": "metadata"
  }
]
```

This shows that there is not a `next` URL (all the information is in this request), and that the URL requested is the first link. When dealing with these URL there are two ways of reading the data in the stream. You can either go to the `last` link and then move backward following `previous` or you can go to the `first` link and follow the `next` links, the final item will not have a next link.

If you want to follow a live stream then you would keep following the `previous` links. When you reach the end of a stream you will receive an empty document with no entries or `previous` link. You then continue polling this URI (in the future a document will appear here). You can see this by trying the `previous` link from the above feed.

<div class="codetabs" markdown="1">
<div data-lang="request" markdown="1">
```bash
curl -i http://127.0.0.1:2113/streams/newstream/1/forward/20 -H "Accept:application/vnd.eventstore.atom+json"
```
</div>
<div data-lang="response" markdown="1">
```http
HTTP/1.1 200 OK
Access-Control-Allow-Methods: GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER, Authorization, ES-LongPoll, ES-ExpectedVersion, ES-EventId, ES-EventType, ES-RequiresMaster, ES-HardDelete, ES-ResolveLinkTo, ES-ExpectedVersion
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location, ES-Position
Cache-Control: max-age=0, no-cache, must-revalidate
Vary: Accept
ETag: "0;248368668"
Content-Type: application/vnd.eventstore.atom+json; charset=utf-8
Server: Mono-HTTPAPI/1.0
Date: Fri, 13 Mar 2015 14:04:47 GMT
Content-Length: 795
Keep-Alive: timeout=15,max=100

{
  "title": "Event stream 'newstream'",
  "id": "<http://127.0.0.1:2113/streams/newstream">,
  "updated": "0001-01-01T00:00:00Z",
  "streamId": "newstream",
  "author": {
    "name": "EventStore"
  },
  "headOfStream": false,
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
      "uri": "http://127.0.0.1:2113/streams/newstream/0/backward/20",
      "relation": "next"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/newstream/metadata",
      "relation": "metadata"
    }
  ],
  "entries": \[]
}
```
</div>
</div>

When parsing an atom subscription the IDs of events will always stay the same. This is important for figuring out if you are referring to the same event.

<!-- TODO: Make this example more generic and covering different installations -->

Let’s now try an example with more than a single page. You can use the testclient that comes with Event Store and use the `VERIFY` command to create fake banking data. After running this command you should find many streams such as `http://127.0.0.1:2113/streams/account-28` in the system.

Opening the link _<http://127.0.0.1:2113/streams/account-28>_ will return:

<div class="codetabs" markdown="1">
<div data-lang="request" markdown="1">
```powershell
curl -i http://127.0.0.1:2113/streams/account-28 -H "Accept:application/vnd.eventstore.atom+json"
```
</div>
<div data-lang="response" markdown="1">
```http
HTTP/1.1 200 OK
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER, Authorization, ES-LongPoll, ES-ExpectedVersion, ES-EventId, ES-EventType, ES-RequiresMaster, ES-HardDelete, ES-ResolveLinkTo, ES-ExpectedVersion
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location, ES-Position
Cache-Control: max-age=0, no-cache, must-revalidate
Vary: Accept
ETag: "180;248368668"
Content-Type: application/vnd.eventstore.atom+json; charset=utf-8
Server: Mono-HTTPAPI/1.0
Date: Fri, 13 Mar 2015 16:08:06 GMT
Content-Length: 11095
Keep-Alive: timeout=15,max=100

{
  "title": "Event stream 'account-28'",
  "id": "<http://127.0.0.1:2113/streams/account-28">,
  "updated": "2015-03-13T16:06:18.47214Z",
  "streamId": "account-28",
  "author": {
    "name": "EventStore"
  },
  "headOfStream": true,
  "selfUrl": "<http://127.0.0.1:2113/streams/account-28">,
  "eTag": "180;248368668",
  "links": [
    {
      "uri": "http://127.0.0.1:2113/streams/account-28",
      "relation": "self"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/account-28/head/backward/20",
      "relation": "first"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/account-28/0/forward/20",
      "relation": "last"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/account-28/160/backward/20",
      "relation": "next"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/account-28/181/forward/20",
      "relation": "previous"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/account-28/metadata",
      "relation": "metadata"
    }
  ],
  "entries": <SNIP>
```
</div>
</div>

Using the links in this response you can traverse through all the events in the stream by going to the `last` URL and walking "previous" or by walking "next" from the “first” link.

If you go to the “last” link you will receive:

<div class="codetabs" markdown="1">
<div data-lang="request" markdown="1">
```powershell
curl -i http://127.0.0.1:2113/streams/account-28/0/forward/20 -H "Accept:application/vnd.eventstore.atom+json"
```
</div>
<div data-lang="response" markdown="1">
```http
HTTP/1.1 200 OK
Access-Control-Allow-Methods: GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER, Authorization, ES-LongPoll, ES-ExpectedVersion, ES-EventId, ES-EventType, ES-RequiresMaster, ES-HardDelete, ES-ResolveLinkTo, ES-ExpectedVersion
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location, ES-Position
Cache-Control: max-age=31536000, public
Vary: Accept
Content-Type: application/vnd.eventstore.atom+json; charset=utf-8
Server: Mono-HTTPAPI/1.0
Date: Fri, 13 Mar 2015 16:16:05 GMT
Content-Length: 10673
Keep-Alive: timeout=15,max=100

{
  "title": "Event stream 'account-28'",
  "id": "<http://127.0.0.1:2113/streams/account-28">,
  "updated": "2015-03-13T16:05:24.262029Z",
  "streamId": "account-28",
  "author": {
    "name": "EventStore"
  },
  "headOfStream": false,
  "links": [
    {
      "uri": "http://127.0.0.1:2113/streams/account-28",
      "relation": "self"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/account-28/head/backward/20",
      "relation": "first"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/account-28/20/forward/20",
      "relation": "previous"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/account-28/metadata",
      "relation": "metadata"
    }
  ],
  "entries":
  <SNIP>
```
</div>
</div>

You then follow its "previous" link until you got back to the head of the document. This is the general way of reading back a stream. Once at the end you can continue reading events as they happen by polling the previous link and you will get events in near real time as they happen.

<span class="note">
All links except the head link are fully cachable as seen in the HTTP header `Cache-Control: max-age=31536000, public`. This is important when discussing intermediaries and performance as you commonly replay a stream from storage.
</span>

<span class="note">
You should **never** bookmark links aside from the head of the stream resource. You should always follow links. We may in the future change how internal links work. If you bookmark link other than the head you will break in these scenarios.
</span>

## Reading All Events

There is a special paged feed for all events that named `$all`. You can use the same paged form of reading described above to read all events for the entire node by pointing the stream at _/streams/$all_. As it's a stream like any other, you can perform all other operations with it except posting to it.

<span class="note">
To access the `$all` stream, you must provide user details, find more information on the [security]({{site.baseurl}}/http-api/security) page.
</span>

<div class="codetabs" markdown="1">
<div data-lang="request" markdown="1">
```bash
curl -i http://127.0.0.1:2113/streams/%24all -H "Accept:application/vnd.eventstore.atom+json" -u admin:changeit
```
</div>
<div data-lang="response" markdown="1">
```http
HTTP/1.1 200 OK
Access-Control-Allow-Methods: POST, DELETE, GET, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER, Authorization, ES-LongPoll, ES-ExpectedVersion, ES-EventId, ES-EventType, ES-RequiresMaster, ES-HardDelete, ES-ResolveLinkTo, ES-ExpectedVersion
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location, ES-Position
Cache-Control: max-age=0, no-cache, must-revalidate
Vary: Accept
ETag: "25159393;248368668"
Content-Type: application/vnd.eventstore.atom+json; charset=utf-8
Server: Mono-HTTPAPI/1.0
Date: Fri, 13 Mar 2015 16:19:09 GMT
Content-Length: 12157
Keep-Alive: timeout=15,max=100

{
  "title": "All events",
  "id": "<http://127.0.0.1:2113/streams/%24all">,
  "updated": "2015-03-13T16:19:06.548415Z",
  "author": {
    "name": "EventStore"
  },
  "headOfStream": false,
  "links": [
    {
      "uri": "http://127.0.0.1:2113/streams/%24all",
      "relation": "self"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/%24all/head/backward/20",
      "relation": "first"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/%24all/00000000000000000000000000000000/forward/20",
      "relation": "last"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/%24all/00000000017BC0D000000000017BC0D0/backward/20",
      "relation": "next"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/%24all/0000000001801EBF0000000001801EBF/forward/20",
      "relation": "previous"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/%24all/metadata",
      "relation": "metadata"
    }
  ],
  "entries": <SNIP>
```
</div>
</div>

## Conditional Gets

The head link supports conditional `GET`s with the use of [ETAGS](http://en.wikipedia.org/wiki/HTTP_ETag), a well known HTTP construct described [here](http://en.wikipedia.org/wiki/HTTP_ETag). You can include the ETAG of your last request and issue a conditional `GET` to the server. If nothing has changed it will not return the full feed. For example:

<div class="codetabs" markdown="1">
<div data-lang="request" markdown="1">
```bash
curl -i http://127.0.01:2113/streams/account-28l -H "Accept:application/vnd.eventstore.atom+json"
```
</div>
<div data-lang="response" markdown="1">
```http
HTTP/1.1 200 OK
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER, Authorization, ES-LongPoll, ES-ExpectedVersion, ES-EventId, ES-EventType, ES-RequiresMaster, ES-HardDelete, ES-ResolveLinkTo, ES-ExpectedVersion
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location, ES-Position
Cache-Control: max-age=0, no-cache, must-revalidate
Vary: Accept
ETag: "180;248368668"
Content-Type: application/vnd.eventstore.atom+json; charset=utf-8
Server: Mono-HTTPAPI/1.0
Date: Fri, 13 Mar 2015 16:23:52 GMT
Content-Length: 11095
Keep-Alive: timeout=15,max=100

…
```
</div>
</div>

The server responded in the headers that the ETag for this content is `ETag: "180;248368668"`. You can use this in your next request when polling the stream for changes by putting it in the header `If-None-Match`. This tells the server to check if the response will be the one you already know.

<div class="codetabs" markdown="1">
<div data-lang="request" markdown="1">
```bash
curl -i http://127.0.0.1:2113/streams/account-28 -H "Accept:application/vnd.eventstore.atom+json" -H "If-None-Match:180;248368668"
```
</div>
<div data-lang="response" markdown="1">
```http
HTTP/1.1 304 Not Modified
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER, Authorization, ES-LongPoll, ES-ExpectedVersion, ES-EventId, ES-EventType, ES-RequiresMaster, ES-HardDelete, ES-ResolveLinkTo, ES-ExpectedVersion
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location, ES-Position
Content-Type: text/plain; charset=utf-8
Server: Mono-HTTPAPI/1.0
Date: Fri, 13 Mar 2015 16:27:53 GMT
Content-Length: 0
Keep-Alive: timeout=15,max=100
```
</div>
</div>

When you use the conditional `GET` the server will return a '304 not modified' response. If the tags have changed, the server will return a '200 OK' response. You can use this method to optimize your application by not sending large streams if there are not changes.

<span class="note">
Etags are created using the version of the stream and the media type you are reading the stream in. You can NOT take an etag from a stream in one media type and use it with another media type.
</span>

## Embedding Data into Stream

So far in this guide, the feeds returned have contained links that refer to the actual event data. This is normally a preferable mechanism for a few reasons.

They can be in a different media type than the feed and can you can negotiate them separately from the feed itself (e.g. the feed in JSON, the event in XML). You can cache the event data separately from the feed and you can point it to different feeds (if you use a `linkTo()` in [projections]({{site.baseurl}}/projections) this is what happens in your atom feeds).

If you are using JSON, you can embed the events into the atom feeds events. This can help cut down on the number of requests in some situations but the messages will be larger.

Though these are mostly used by the StreamUI component in the Web API there are ways of embedding events and/or further metadata into your stream controlled by the `embed=` parameter.

### Rich

The `rich` embed mode will return more properties about the event (`eventtype`, `streamid`, `position`, etc) as you can see in the following request.

<div class="codetabs" markdown="1">
<div data-lang="request" markdown="1">
```bash
curl -i -H "Accept:application/vnd.eventstore.atom+json" "http://127.0.0.1:2113/streams/newstream?embed=rich"
```
</div>
<div data-lang="response" markdown="1">
```http
HTTP/1.1 200 OK
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER, Authorization, ES-LongPoll, ES-ExpectedVersion, ES-EventId, ES-EventType, ES-RequiresMaster, ES-HardDelete, ES-ResolveLinkTo, ES-ExpectedVersion
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location, ES-Position
Cache-Control: max-age=0, no-cache, must-revalidate
Vary: Accept
ETag: "0;248368668"
Content-Type: application/vnd.eventstore.atom+json; charset=utf-8
Server: Mono-HTTPAPI/1.0
Date: Fri, 13 Mar 2015 16:30:57 GMT
Content-Length: 1570
Keep-Alive: timeout=15,max=100

{
  "title": "Event stream 'newstream'",
  "id": "<http://127.0.0.1:2113/streams/newstream">,
  "updated": "2015-03-13T12:13:42.492473Z",
  "streamId": "newstream",
  "author": {
    "name": "EventStore"
  },
  "headOfStream": true,
  "selfUrl": "<http://127.0.0.1:2113/streams/newstream">,
  "eTag": "0;248368668",
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
      "uri": "http://127.0.0.1:2113/streams/newstream/1/forward/20",
      "relation": "previous"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/newstream/metadata",
      "relation": "metadata"
    }
  ],
  "entries": \[
    {
      "eventId": "fbf4a1a1-b4a3-4dfe-a01f-ec52c34e16e4",
      "eventType": "event-type",
      "eventNumber": 0,
      "streamId": "newstream",
      "isJson": true,
      "isMetaData": false,
      "isLinkMetaData": false,
      "positionEventNumber": 0,
      "positionStreamId": "newstream",
      "title": "0@newstream",
      "id": "<http://127.0.0.1:2113/streams/newstream/0">,
      "updated": "2015-03-13T12:13:42.492473Z",
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
</div>
</div>

### Body

The `body` embed mode will return the JSON/XML body of the events into the feed as well, depending on the type of the feed. You can see this in the request below:

<div class="codetabs" markdown="1">
<div data-lang="request" markdown="1">
```bash
curl -i -H "Accept:application/vnd.eventstore.atom+json" "http://127.0.0.1:2113/streams/newstream?embed=body"
```
</div>
<div data-lang="response" markdown="1">
```http
HTTP/1.1 200 OK
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER, Authorization, ES-LongPoll, ES-ExpectedVersion, ES-EventId, ES-EventType, ES-RequiresMaster, ES-HardDelete, ES-ResolveLinkTo, ES-ExpectedVersion
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location, ES-Position
Cache-Control: max-age=0, no-cache, must-revalidate
Vary: Accept
ETag: "0;248368668"
Content-Type: application/vnd.eventstore.atom+json; charset=utf-8
Server: Mono-HTTPAPI/1.0
Date: Fri, 13 Mar 2015 16:32:06 GMT
Content-Length: 1608
Keep-Alive: timeout=15,max=100

{
  "title": "Event stream 'newstream'",
  "id": "<http://127.0.0.1:2113/streams/newstream">,
  "updated": "2015-03-13T12:13:42.492473Z",
  "streamId": "newstream",
  "author": {
    "name": "EventStore"
  },
  "headOfStream": true,
  "selfUrl": "<http://127.0.0.1:2113/streams/newstream">,
  "eTag": "0;248368668",
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
      "uri": "http://127.0.0.1:2113/streams/newstream/1/forward/20",
      "relation": "previous"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/newstream/metadata",
      "relation": "metadata"
    }
  ],
  "entries": \[
    {
      "eventId": "fbf4a1a1-b4a3-4dfe-a01f-ec52c34e16e4",
      "eventType": "event-type",
      "eventNumber": 0,
      "data": "{\\n  "a": "1"\\n}",
      "streamId": "newstream",
      "isJson": true,
      "isMetaData": false,
      "isLinkMetaData": false,
      "positionEventNumber": 0,
      "positionStreamId": "newstream",
      "title": "0@newstream",
      "id": "<http://127.0.0.1:2113/streams/newstream/0">,
      "updated": "2015-03-13T12:13:42.492473Z",
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
</div>
</div>

If you use XML format then no additional data is embedded, as embedding is only supported with JSON.

<div class="codetabs" markdown="1">
<div data-lang="request" markdown="1">
```bash
curl -i -H "Accept:application/atom+xml" "http://127.0.0.1:2113/streams/newstream?embed=body"
```
</div>
<div data-lang="response" markdown="1">
```http
HTTP/1.1 200 OK
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER, Authorization, ES-LongPoll, ES-ExpectedVersion, ES-EventId, ES-EventType, ES-RequiresMaster, ES-HardDelete, ES-ResolveLinkTo, ES-ExpectedVersion
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location, ES-Position
Cache-Control: max-age=0, no-cache, must-revalidate
Vary: Accept
ETag: "0;-1296467268"
Content-Type: application/atom+xml; charset=utf-8
Server: Mono-HTTPAPI/1.0
Date: Fri, 13 Mar 2015 16:32:56 GMT
Content-Length: 929
Keep-Alive: timeout=15,max=100
<?xml version="1.0" encoding="UTF-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
   <title>Event stream 'newstream'</title>
   <id>http://127.0.0.1:2113/streams/newstream</id>
   <updated>2013-06-29T15:12:53.570125Z</updated>
   <author>
      <name>EventStore</name>
   </author>
   <link href="http://127.0.0.1:2113/streams/newstream" rel="self" />
   <link href="http://127.0.0.1:2113/streams/newstream/head/backward/20" rel="first" />
   <link href="http://127.0.0.1:2113/streams/newstream/0/forward/20" rel="last" />
   <link href="http://127.0.0.1:2113/streams/newstream/1/forward/20" rel="previous" />
   <link href="http://127.0.0.1:2113/streams/newstream/metadata" rel="metadata" />
   <entry>
      <title>0@newstream</title>
      <id>http://127.0.0.1:2113/streams/newstream/0</id>
      <updated>2013-06-29T15:12:53.570125Z</updated>
      <author>
         <name>EventStore</name>
      </author>
      <summary>event-type</summary>
      <link href="http://127.0.0.1:2113/streams/newstream/0" rel="edit" />
      <link href="http://127.0.0.1:2113/streams/newstream/0" rel="alternate" />
   </entry>
</feed>
```
</div>
</div>

There are two other modes that are variants of `body`. `PrettyBody` which will try to reformat the JSON to make it "pretty to read", and `TryHarder` that will work harder to try to parse and reformat JSON from an event to return it in the feed. These do not include further information, they are focused on how the feed looks.
