---
title: "Deleting a Stream"
section: "HTTP API"
version: "4.0.2"
---

To delete a stream over the Atom interface, issue a `DELETE` request to the resource.

<span class="note">
The documentation here applies to versions after 2.0.1. Prior to 2.0.1 only hard deletes were available and the system uses that behavior.
</span>

## Example

Create a stream with the following request:

<div class="codetabs" markdown="1">
<div data-lang="request" markdown="1">
```bash
curl -i -d @event.txt http://127.0.0.1:2113/streams/foo -H "Content-Type: application/json"
```
</div>
<div data-lang="response" markdown="1">
```http
HTTP/1.1 201 Created
Content-Length: 0
Content-Type: text/plain; charset=utf-8
Location: http://127.0.0.1:2113/streams/foo/0
Server: Microsoft-HTTPAPI/2.0
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER, Authorization
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location
Date: Thu, 13 Mar 2014 20:39:12 GMT
```
</div>
</div>
Then delete the stream with a `DELETE` request to the stream resource:

<div class="codetabs" markdown="1">
<div data-lang="request" markdown="1">
```bash
curl -v -X DELETE http://127.0.0.1:2113/streams/foo
```
</div>
<div data-lang="response" markdown="1">
```http
HTTP/1.1 204 Stream deleted
Content-Length: 0
Content-Type: text/plain; charset=utf-8
Server: Microsoft-HTTPAPI/2.0
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER, Authorization
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location
Date: Thu, 13 Mar 2014 20:40:05 GMT
```
</div>
</div>

By default when you delete a stream it is soft deleted. This means you can recreate it later if you want to by setting the `$tb` metadata section as the client API does <!-- Link? -->. If you try to `GET` a soft deleted stream you will receive a 404 response:

<div class="codetabs" markdown="1">
<div data-lang="request" markdown="1">
```bash
curl -i http://127.0.0.1:2113/streams/foo
```
</div>
<div data-lang="response" markdown="1">
```http
HTTP/1.1 404 Not Found
Content-Length: 0
Content-Type: text/plain; charset=utf-8
Server: Microsoft-HTTPAPI/2.0
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER, Authorization
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location
Date: Thu, 13 Mar 2014 20:47:18 GMT
```
</div>
</div>

If desired, you can recreate the stream by appending new events to it (like creating a new stream):

<div class="codetabs" markdown="1">
<div data-lang="request" markdown="1">
```bash
curl -i -d @event.txt http://127.0.0.1:2113/streams/foo -H "Content-Type:application/json"
```
</div>
<div data-lang="response" markdown="1">
```http
HTTP/1.1 201 Created
Content-Length: 0
Content-Type: text/plain; charset=utf-8
Location: http://127.0.0.1:2113/streams/foo/1
Server: Microsoft-HTTPAPI/2.0
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER, Authorization
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location
Date: Thu, 13 Mar 2014 20:49:30 GMT
```
</div>
</div>

If you `GET` a stream that has been soft deleted and then recreated you will notice that the version numbers do not start at zero but at where you soft deleted the stream from:

<div class="codetabs" markdown="1">
<div data-lang="request" markdown="1">
```bash
curl -i http://127.0.0.1:2113/streams/foo
```
</div>
<div data-lang="response" markdown="1">
```http
HTTP/1.1 200 OK
Cache-Control: max-age=0, no-cache, must-revalidate
Content-Length: 1215
Content-Type: application/vnd.eventstore.atom+json; charset=utf-8
ETag: "1;-2060438500"
Vary: Accept
Server: Microsoft-HTTPAPI/2.0
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER, Authorization
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location
Date: Thu, 13 Mar 2014 20:49:34 GMT

{
  "title": "Event stream 'foo'",
  "id": "<http://127.0.0.1:2113/streams/foo">,
  "updated": "2014-03-13T20:49:30.3821623Z",
  "streamId": "foo",
  "author": {
    "name": "EventStore"
  },
  "headOfStream": true,
  "selfUrl": "<http://127.0.0.1:2113/streams/foo">,
  "links": [
    {
      "uri": "http://127.0.0.1:2113/streams/foo",
      "relation": "self"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/foo/head/backward/20",
      "relation": "first"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/foo/2/forward/20",
      "relation": "previous"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/foo/metadata",
      "relation": "metadata"
    }
  ],
  "entries": \[
    {
      "title": "1@foo",
      "id": "<http://127.0.0.1:2113/streams/foo/1">,
      "updated": "2014-03-13T20:49:30.3821623Z",
      "author": {
        "name": "EventStore"
      },
      "summary": "chatMessage",
      "links": [
        {
          "uri": "http://127.0.0.1:2113/streams/foo/1",
          "relation": "edit"
        },
        {
          "uri": "http://127.0.0.1:2113/streams/foo/1",
          "relation": "alternate"
        }
      ]
    }
  ]
}

    </div>
    </div>

    So far we have looked at soft deletes. You can also execute hard deletes on a stream. To issue a permanent delete use the `ES-HardDelete` header.

    <span class="note--warning">
    A hard delete is permanent and the stream is not removed during a scavenge. If you hard delete a stream, the stream can never be recreated.
    </span>

    Create a stream with the following request:

    <div class="codetabs" markdown="1">
    <div data-lang="request" markdown="1">
    ```bash
    curl -i -d @event.txt http://127.0.0.1:2113/streams/foo2 -H "Content-Type:application/json"

</div>
<div data-lang="response" markdown="1">
```http
HTTP/1.1 201 Created
Content-Length: 0
Content-Type: text/plain; charset=utf-8
Location: http://127.0.0.1:2113/streams/foo2/1
Server: Microsoft-HTTPAPI/2.0
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER, Authorization
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location
Date: Thu, 13 Mar 2014 20:54:24 GMT
```
</div>
</div>

Then issue the `DELETE` as before but with the permanent delete header:

<div class="codetabs" markdown="1">
<div data-lang="request" markdown="1">
```bash
curl -v -X DELETE http://127.0.0.1:2113/streams/foo2 -H "ES-HardDelete:true"
```
</div>
<div data-lang="response" markdown="1">
```http
HTTP/1.1 204 Stream deleted
Content-Length: 0
Content-Type: text/plain; charset=utf-8
Server: Microsoft-HTTPAPI/2.0
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER, Authorization
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location
Date: Thu, 13 Mar 2014 20:56:55 GMT
```
</div>
</div>

This stream is now permanently deleted, and unlike before where you received a '404' response, the response will now be a '410 GONE'.

<div class="codetabs" markdown="1">
<div data-lang="request" markdown="1">
```bash
curl -i http://127.0.0.1:2113/streams/foo2
```
</div>
<div data-lang="response" markdown="1">
```http
HTTP/1.1 410 Deleted
Content-Length: 0
Content-Type: text/plain; charset=utf-8
Server: Microsoft-HTTPAPI/2.0
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER, Authorization
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location
Date: Thu, 13 Mar 2014 20:57:01 GMT
```
</div>
</div>

If you try to recreate the stream as in the above example you will also receive a '410 GONE' response.

<div class="codetabs" markdown="1">
<div data-lang="request" markdown="1">
```bash
curl -i -d @event.txt http://127.0.0.1:2113/streams/foo2 -H "Content-Type:application/json"
```
</div>
<div data-lang="response" markdown="1">
```http
HTTP/1.1 410 Stream deleted
Content-Length: 0
Content-Type: text/plain; charset=utf-8
Server: Microsoft-HTTPAPI/2.0
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER, Authorization
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location
Date: Thu, 13 Mar 2014 21:00:00 GMT
```
</div>
</div>

The same applies if you try to delete an already deleted stream. You will receive a '410 GONE' response.

<div class="codetabs" markdown="1">
<div data-lang="request" markdown="1">
```bash
curl -i -X DELETE http://127.0.0.1:2113/streams/foo2 -H "ES-HardDelete: true"
```
</div>
<div data-lang="response" markdown="1">
```http
HTTP/1.1 410 Stream deleted
Content-Length: 0
Content-Type: text/plain; charset=utf-8
Server: Microsoft-HTTPAPI/2.0
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER, Authorization
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location
Date: Thu, 13 Mar 2014 21:19:33 GMT
```
</div>
</div>
