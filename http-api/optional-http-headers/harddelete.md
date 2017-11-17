---
title: "Optional HTTP Headers: HardDelete"
section: "HTTP API"
version: "4.0.2"
exclude_from_sidebar: true
---

The `ES-HardDelete` header controls deleting a stream. By default Event Store will soft delete a stream allowing you to later reuse that stream. If you set the `ES-HardDelete` header the stream will be permanently deleted.

<div class="codetabs" markdown="1">
<div data-lang="request" markdown="1">
```bash
curl -v -X DELETE http://127.0.0.1:2113/streams/foo -H "ES-HardDelete:true"
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

This changes the general behavior from returning a '404' and recreatable to having the stream now return '410 GONE' forever.

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
