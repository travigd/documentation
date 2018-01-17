---
title: "Overview"
section: "HTTP API"
version: "4.0.2"
pinned: true
---

Event Store provides a native interface of AtomPub over HTTP. AtomPub is a RESTful protocol that can reuse many existing components, for example reverse proxies and a client’s native HTTP caching. Since events stored in Event Store are entirely immutable, cache expiration can be infinite. Event Store leverages content type negotiation and you can access appropriately serialised events can as JSON or XML according to the request headers.

> [!NOTE]
>
Examples in this section make use of the command line tool [cURL](http://curl.haxx.se/) to construct HTTP requests. We use this tool regularly in development and you will find it useful when working with the HTTP API.


## Compatibility with AtomPub

Event Store is fully compatible with the 1.0 version of the Atom Protocol. Event Store adds extensions to the protocol, such as headers for control and custom `rel` links.

### Content Types

The preferred way of determining which content type responses Event Store serves is to set the `Accept` header on the request. As some clients do not deal well with HTTP headers when caching, appending a format parameter to the URL is also supported, e.g. `?format=xml`.

The accepted content types for POST requests are:

- `application/xml`
- `application/vnd.eventstore.events+xml`
- `application/json`
- `application/vnd.eventstore.events+json`
- `text/xml`

The accepted content types for GET requests are:

- `application/xml`
- `application/atom+xml`
- `application/json`
- `application/vnd.eventstore.atom+json`
- `text/xml`
- `text/html`

There will be additions in the future for protobufs and bson.

## Examples

Below are examples of [writing](/http-api/writing-to-a-stream) an event to a stream, as well as [reading](../reading-streams) both a stream, and an event, for more details on these read out their individual pages. All the below example use JSON, but by setting the correct content types then the examples would apply to XML as well.

### Writing an event to a stream.

Inside a file named _simple-event.txt_:

```json
[
  {
    "eventId": "fbf4a1a1-b4a3-4dfe-a01f-ec52c34e16e4",
    "eventType": "event-type",
    "data": { "a": "1" }
  }
]
```

Issuing a `POST` request with the above data to a stream, with the correct content type set, will result in writing the event to the stream, and a `201` response from the server, giving you the location of the event.

<div class="codetabs" markdown="1">
<div data-lang="request" markdown="1">
```json
curl -i -d @simple-event.txt -H "Content-Type:application/vnd.eventstore.events+json" "http://127.0.0.1:2113/streams/newstream"
```
</div>
<div data-lang="response" markdown="1">
```http
HTTP/1.1 201 Created
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER, Authorization, ES-LongPoll, ES-ExpectedVersion, ES-EventId, ES-EventType, ES-RequiresMaster, ES-HardDelete, ES-ResolveLinkTo, ES-ExpectedVersion
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location, ES-Position
Location: http://127.0.0.1:2113/streams/newstream2/0
Content-Type: text/plain; charset=utf-8
Server: Mono-HTTPAPI/1.0
Date: Thu, 29 Jan 2015 14:28:05 GMT
Content-Length: 0
Keep-Alive: timeout=15,max=100
```
</div>
</div>

### Reading a stream

<div class="codetabs" markdown="1">
<div data-lang="request" markdown="1">
```json
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
Date: Thu, 29 Jan 2015 14:10:42 GMT
Content-Length: 1260
Keep-Alive: timeout=15,max=100

{
  "title": "Event stream 'newstream'",
  "id": "http://127.0.0.1:2113/streams/newstream",
  "updated": "2015-01-29T10:13:38.564802Z",
  "streamId": "newstream",
  "author": {
    "name": "EventStore"
  },
  "headOfStream": true,
  "selfUrl": "http://127.0.0.1:2113/streams/newstream",
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
  "entries": [
    {
      "title": "0@newstream",
      "id": "http://127.0.0.1:2113/streams/newstream/0",
      "updated": "2015-01-29T10:13:38.564802Z",
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

### Reading an event from a stream

<div class="codetabs" markdown="1">
<div data-lang="request" markdown="1">
```bash
curl -i -H "Accept:application/vnd.eventstore.atom+json" "http://127.0.0.1:2113/streams/newstream/0"
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
Date: Thu, 29 Jan 2015 15:45:45 GMT
Content-Length: 572
Keep-Alive: timeout=15,max=100

{
  "title": "0@newstream",
  "id": "http://127.0.0.1:2113/streams/newstream/0",
  "updated": "2015-01-29T10:13:38.564802Z",
  "author": {
    "name": "EventStore"
  },
  "summary": "event-type",
  "content": {
    "eventStreamId": "newstream",
    "eventNumber": 0,
    "eventType": "event-type",
    "data": {
      "a": "1"
    },
    "metadata": ""
  },
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
```
</div>
</div>
