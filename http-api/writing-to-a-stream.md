---
uid: eventstore.org/Event Store HTTP API/4.0.2/createStream
---
# Writing to a Stream

You write to a stream over HTTP using a `POST` request to the resource of the stream. If the stream does not exist then the stream will be implicitly created.

## Single Event

> [!NOTE]
> Writing a single event has changed from Event Store 2.X.X to Event Store 3.X.X.
> In Event Store 3.X.X a post of `application/json` assumes the post data to be the actual event.
> When you need to write multiple events, use `application/vnd.eventstore.events+json` instead.

Issuing a `POST` request with the data below to a stream, with the correct content type set, will result in writing the event to the stream, and a `201` response from the server, giving you the location of the event.

In a file named _myevent.txt_

```json
[
  {
    "eventId": "fbf4a1a1-b4a3-4dfe-a01f-ec52c34e16e4",
    "eventType": "event-type",
    "data": { "a": "1" }
  }
]
```

`POST` the following request:

### [Request](#tab/tabid-1)

```bash
curl -i -d @myevent.txt "http://127.0.0.1:2113/streams/newstream" -H "Content-Type:application/json" -H "ES-EventType: SomeEvent"
```

### [Response](#tab/tabid-2)

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

* * *

The event will be available in the stream. Some clients may not be able to generate a GUID (or may not want to generate a GUID) for the ID. You need this ID for idempotence purposes but the server can generate it for you. If we were to leave off the `ES-EventId` header you would see different behavior:

### [Request](#tab/tabid-1)

```bash
curl -i -d @myevent.txt "http://127.0.0.1:2113/streams/newstream" -H "Content-Type:application/json" -H "ES-EventType: SomeEvent"
```

### [Response](#tab/tabid-2)

```http
HTTP/1.1 301 FOUND
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER, Authorization, ES-LongPoll
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location, ES-Position
Location: http://127.0.0.1:2113/streams/newstream/incoming/ad1c1288-0d61-4995-88b2-06c57a42495b
Content-Type: ; charset=utf-8
Server: Mono-HTTPAPI/1.0
Date: Mon, 21 Apr 2014 21:01:29 GMT
Content-Length: 28
Keep-Alive: timeout=15,max=100
```

* * *

In this case Event Store has responded with a `301 redirect`. The location points to another URI that you can post the event to. This new URI will be idempotent for posting to even without an event ID.

### [Request](#tab/tabid-1)

```bash
curl -i -d @myevent.txt "http://127.0.0.1:2113/streams/newstream/incoming/ad1c1288-0d61-4995-88b2-06c57a42495b" -H "Content-Type: application/json" -H "ES-EventType: SomeEvent"
```

### [Response](#tab/tabid-2)

```http
HTTP/1.1 201 Created
Access-Control-Allow-Methods: GET, POST, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER, Authorization, ES-LongPoll
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location, ES-Position
Location: http://127.0.0.1:2113/streams/newstream/0
Content-Type: text/plain; charset=utf-8
Server: Mono-HTTPAPI/1.0
Date: Mon, 21 Apr 2014 21:15:33 GMT
Content-Length: 0
Keep-Alive: timeout=15,max=100
```

* * *

It is generally recommended to include an event ID if possible as it will result in fewer round trips between the client and the server.

When posting to either the stream or to the returned redirect clients must include the `EventType` header. If you forget to include the header you will receive an error.

### [Request](#tab/tabid-1)

```bash
curl -i -d @myevent.txt "http://127.0.0.1:2113/streams/newstream" -H "Content-Type:application/json"
```

### [Response](#tab/tabid-2)

```http
HTTP/1.1 400 Must include an event type with the request either in body or as ES-EventType header.
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER, Authorization, ES-LongPoll
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location, ES-Position
Content-Type:
Server: Mono-HTTPAPI/1.0
Date: Mon, 21 Apr 2014 21:05:45 GMT
Content-Length: 0
Connection: close
```

* * *

## Event Store Events Media Type

Event store supports a custom media type for posting events `application/vnd.eventstore.events (+json/+xml)`. This format allows for extra functionality that posting events as above does not. For example it allows you to post multiple events in a single batch.

In a file named _simple-event.txt_:

```json
[
  {
    "eventId": "fbf4a1a1-b4a3-4dfe-a01f-ec52c34e16e4",
    "eventType": "event-type",
    "data": { "a": "1" }
  }
]
```

The data is represented by the following jschema (`eventId` must be a UUID).

```json
[
    {
      "eventId"    : "string",
      "eventType"  : "string",
      "data"       : "object",
      "metadata"   : "object"
    }
]
```

### Create a Stream

To create a stream, issue a `POST` request to the `/streams/newstream` resource:

### [Request](#tab/tabid-1)

```bash
curl -i -d @event.txt "http://127.0.0.1:2113/streams/newstream" -H "Content-Type:application/vnd.eventstore.events+json"
```

### [Response](#tab/tabid-2)

```http
HTTP/1.1 201 Created
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER
Access-Control-Allow-Origin: *
Location: http://127.0.0.1:2113/streams/newstream/0
Content-Type: text/plain; charset: utf-8
Server: Mono-HTTPAPI/1.0
Date: Fri, 28 Jun 2013 12:17:59 GMT
Content-Length: 0
Keep-Alive: timeout=15,max=100
```

* * *

### Appending Events

To append events, issue a `POST` request to the same resource again and edit the message ID GUID:

<!-- TODO: This doesn't show that -->

### [Request](#tab/tabid-1)

```bash
curl -i -d @event.txt "http://127.0.0.1:2113/streams/newstream" -H "Content-Type:application/vnd.eventstore.events+json"
```

### [Response](#tab/tabid-2)

```http
HTTP/1.1 201 Created
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER
Access-Control-Allow-Origin: *
Location: http://127.0.0.1:2113/streams/newstream/1
Content-Type: text/plain; charset: utf-8
Server: Mono-HTTPAPI/1.0
Date: Fri, 28 Jun 2013 12:32:18 GMT
Content-Length: 0
Keep-Alive: timeout=15,max=100
```

* * *

### Data only events

Version 3.7.0 of Event Store added support for the `application/octet-stream` content type to support data only events. When creating these events, you will need to provide the `ES-EventType` and `ES-EventId` headers and cannot have metadata associated with the Event. In the example below `SGVsbG8gV29ybGQ=` is the data you `POST` to the stream:

### [Request](#tab/tabid-1)

```bash
curl -i -d "SGVsbG8gV29ybGQ=" "http://127.0.0.1:2113/streams/newstream" -H "Content-Type:application/octet-stream" -H "ES-EventType:rawDataType" -H "ES-EventId:eeccf3ce-4f54-409d-8870-b35dd836cca6"
```

### [Response](#tab/tabid-2)

```http
HTTP/1.1 201 Created
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-Forwarded-Host, X-PINGOTHER, Authorization, ES-LongPoll, ES-ExpectedVersion, ES-EventId, ES-EventType, ES-RequiresMaster, ES-HardDelete, ES-ResolveLinkTo, ES-ExpectedVersion
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location, ES-Position
Location: http://127.0.0.1:2113/streams/newstream/0
Content-Type: text/plain; charset=utf-8
Server: Mono-HTTPAPI/1.0
Date: Mon, 27 Jun 2016 13:15:27 GMT
Content-Length: 0
Keep-Alive: timeout=15,max=100
```

* * *

## Expected Version

The expected version header is a number representing the version of the stream you read from. For example if you read from the stream and it was at version 5 then you expect it to be at version 5. This can allow for optimistic locking when multiple applications are reading/writing to streams. If your expected version is not the current version you will receive a HTTP status code of 400.

> [!NOTE]
>
> See the idempotency section below, if you post the same event twice it will be idempotent and will not give a version error.

### [Request](#tab/tabid-1)

```bash
curl -i -d @event.txt "http://127.0.0.1:2113/streams/newstream" -H "Content-Type:application/json" -H "ES-ExpectedVersion: 3"
```

### [Response](#tab/tabid-2)

```http
HTTP/1.1 400 Wrong expected EventNumber
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER
Access-Control-Allow-Origin: *
Content-Type: text/plain; charset: utf-8
Server: Mono-HTTPAPI/1.0
Date: Fri, 28 Jun 2013 12:33:30 GMT
Content-Length: 0
Connection: close
```

* * *

There are some special values you can put into the expected version header.

-   `-2` states that this write should never conflict and should always succeed.
-   `-1` states that the stream should not exist at the time of the writing (this write will create it).
-   `0` states that the stream should exist but should be empty.

## Batch Writes

You can include more than one write in a single post by placing multiple events inside of the array representing the events, you can include metadata.

The following post body inserts two events:

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

When you write multiple events in a single post, Event Store treats them transactionally, it writes all events together or all will fail.

### Idempotency

Appends to streams are idempotent based upon the `EventId` assigned in your post. If you were to re-run the last cURL command it will return the same value again.

### [Request](#tab/tabid-1)

```bash
curl -i -d @event.txt "http://127.0.0.1:2113/streams/newstream" -H "Content-Type:application/json"
```

### [Response](#tab/tabid-2)

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

* * *

This is important behaviour as this is how you implement error handling. If you receive a timeout, broken connection, no answer, etc from your HTTP `POST` then it's your responsibility is to retry the post. You must also keep the same `uuid` that you assigned to the event in the first `POST`.

If you are using the expected version parameter with your message, then Event Store is 100% idempotent. If you use `Any` as your expected version value, Event Store will do its best to keep events idempotent but cannot assure that everything is fully idempotent and you will end up in 'at-least-once' messaging. [Read this guide](~/http-api/optimistic-concurrency-and-idempotence.md) for more details on idempotency.

This idempotency also applies to the URIs generated by the server if you post a body as an event without the `ES-EventId` header associated with the request:

### [Request](#tab/tabid-1)

```bash
curl -i -d @event.txt "http://127.0.0.1:2113/streams/newstream" -H "Content-Type:application/json" -H "ES-EventType: SomeEvent"
```

### [Response](#tab/tabid-2)

```http
HTTP/1.1 301 FOUND
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER, Authorization, ES-LongPoll
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location, ES-Position
Location: http://127.0.0.1:2113/streams/newstream/incoming/c7248fc1-3db4-42c1-96aa-a071c92649d1
Content-Type: ; charset=utf-8
Server: Mono-HTTPAPI/1.0
Date: Mon, 21 Apr 2014 21:11:59 GMT
Content-Length: 28
Keep-Alive: timeout=15,max=100
```

* * *

You can then post multiple times to the generated redirect URI and Event Store will make the requests will idempotent for you:

### [Request](#tab/tabid-1)

```bash
curl -i -d @event.txt "http://127.0.0.1:2113/streams/newstream/incoming/c7248fc1-3db4-42c1-96aa-a071c92649d1" -H "Content-Type: application/json" -H "ES-EventType: SomeEvent"
```

### [Response](#tab/tabid-2)

```http
HTTP/1.1 201 Created
Access-Control-Allow-Methods: GET, POST, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER, Authorization, ES-LongPoll
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location, ES-Position
Location: http://127.0.0.1:2113/streams/newstream/0
Content-Type: text/plain; charset=utf-8
Server: Mono-HTTPAPI/1.0
Date: Mon, 21 Apr 2014 21:14:28 GMT
Content-Length: 0
Keep-Alive: timeout=15,max=100
```

* * *

If you retry the post:

### [Request](#tab/tabid-1)

```bash
curl -i -d @event.txt "http://127.0.0.1:2113/streams/newstream/incoming/c7248fc1-3db4-42c1-96aa-a071c92649d1" -H "Content-Type: application/json" -H "ES-EventType: SomeEvent"
```

### [Response](#tab/tabid-2)

```http
HTTP/1.1 201 Created
Access-Control-Allow-Methods: GET, POST, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER, Authorization, ES-LongPoll
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location, ES-Position
Location: http://127.0.0.1:2113/streams/newstream/0
Content-Type: text/plain; charset=utf-8
Server: Mono-HTTPAPI/1.0
Date: Mon, 21 Apr 2014 21:15:33 GMT
Content-Length: 0
Keep-Alive: timeout=15,max=100
```

* * *
