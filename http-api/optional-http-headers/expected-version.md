---
outputFileName: index.html
---

# Optional HTTP Headers: Expected Version

When writing to a stream you often want to use `Expected Version` to allow for optimistic concurrency with a stream.

i.e. my write can succeed if I have seen everyone else's writes.

You most commonly use this for a domain object projection, You can set `ExpectedVersion` as `ES-ExpectedVersion: #`.

By default the `ES-ExpectedVersion` is `-2` (append). You can set an actual version number as well or `-1` to say that the stream should not exist when processing (e.g. you expect to be creating it), or `-4` to say that the stream should exist with any number of events in it.

If the `ExpectedVersion` does not match the version of the stream, Event Store will return an HTTP 400 `Wrong expected EventNumber` response. This response contains the current version of the stream in an `ES-CurrentVersion` header.

In the following cURL command `ExpectedVersion` is not set (and it will append or create/append to the stream).

### [Request](#tab/tabid-1)

```bash
curl -i -d @event.js "http://127.0.0.1:2113/streams/newstream" -H "Content-Type:application/json"
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
Date: Thu, 27 Jun 2013 14:26:14 GMT
Content-Length: 0
Keep-Alive: timeout=15,max=100
```
***

The stream 'newstream' now has one event. If appending with an expected version of '3' this will not work.

### [Request](#tab/tabid-3)

```bash
curl -i -d @event.js "http://127.0.0.1:2113/streams/newstream" -H "Content-Type:application/json" -H "ES-ExpectedVersion: 3"
```

### [Response](#tab/tabid-4)

```http
HTTP/1.1 400 Wrong expected EventNumber
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER
Access-Control-Allow-Origin: *
ES-CurrentVersion: 0
Content-Type: text/plain; charset: utf-8
Server: Mono-HTTPAPI/1.0
Date: Thu, 27 Jun 2013 14:27:24 GMT
Content-Length: 0
Connection: close
```
***

You can see from the `ES-CurrentVersion` header above that the stream is at version zero. Appending with an expected version of zero will work. The expected version is always the version of the last event you know of in the stream.

### [Request](#tab/tabid-5)

```bash
curl -i -d @event.js "http://127.0.0.1:2113/streams/newstream" -H "Content-Type:application/json" -H "ES-ExpectedVersion: 0"
```

### [Response](#tab/tabid-6)

```http
HTTP/1.1 201 Created
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER
Access-Control-Allow-Origin: *
Location: http://127.0.0.1:2113/streams/newstream/1
Content-Type: text/plain; charset: utf-8
Server: Mono-HTTPAPI/1.0
Date: Thu, 27 Jun 2013 14:47:10 GMT
Content-Length: 0
Keep-Alive: timeout=15,max=100
```
***