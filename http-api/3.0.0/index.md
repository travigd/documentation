---
title: "Overview"
section: "HTTP API"
version: 3.0.0
pinned: true
---

The Event Store provides a native interface of AtomPub over HTTP. AtomPub is a RESTful protocol that can reuse many existing components, for example Reverse Proxies and client’s native HTTP caching. Since events stored in the Event Store are entirely immutable, cache expiration can be infinite. We can also leverage content type negotiation. Appropriately serialized events can be accessed as JSON or XML according to the request headers.

<span class="note">
Examples in this section make use of the command line tool
[cURL](http://curl.haxx.se/) to construct HTTP requests. We use this tool
regularly in development and likely you will find it quite useful as well when
working with the HTTP API.
</span>

## Compatibility with AtomPub

The Event Store is fully compatible with the 1.0 version of the Atom Protocol. If problems are found the protocol specified behaviour will be followed in future releases. There are however extensions to the protocol that have been made such as headers for control and custom `rel` links.

### Content Types

The preferred way of determining which content type responses will be served is to set the Accept header on the request. However, as some clients do not deal well with HTTP headers when caching, appending a format parameter to the URL is also supported, e.g. `?format=xml`.

The accepted content types for POST requests are currently:

- `application/xml`
- `application/vnd.eventstore.events+xml`
- `application/json`
- `application/vnd.eventstore.events+json`
- `text/xml`

The accepted content types for GET requests are currently:

- `application/xml`
- `application/atom+xml`
- `application/json`
- `application/vnd.eventstore.atom+json` 
- `text/xml`
- `text/html`

There will likely be additions in the future for protobufs and bson.

## Examples

### Writing an event to a stream.

simple-event.txt:
```json
[
    {
        "EventId": "0f9fad5b-d9cb-469f-a165-70867728951e",
        "EventType": "Type",    
        "Data": {
            "Foo": "Bar"
        },
        "Metadata": {
            "Something": "AValue"
        }
    }
]
```

Posting the above data to a stream, with the correct content type set, will result in the event being written to the stream, and a `201` response from the server, giving you the location of the event.

```
curl -i -d @simple-event.txt -H "Content-Type:application/vnd.eventstore.events+json" "http://127.0.0.1:2113/streams/newstream2"
```

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

### Reading a stream

```
curl -i -H "Accept:application/vnd.eventstore.atom+json" "http://127.0.0.1:2113/streams/newstream"
```

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
```

```json
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

### Reading an event from a stream

```
curl -i -H "Accept:application/vnd.eventstre.atom+json" "http://127.0.0.1:2113/streams/newstream/0"
```

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
```

```json
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