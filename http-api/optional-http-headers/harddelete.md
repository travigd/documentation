---
outputFileName: index.html
---

# Optional HTTP Headers: HardDelete

The `ES-HardDelete` header controls deleting a stream. By default Event Store will soft delete a stream allowing you to later reuse that stream. If you set the `ES-HardDelete` header the stream will be permanently deleted.

### [Request](#tab/tabid-1)
```bash
curl -v -X DELETE http://127.0.0.1:2113/streams/foo -H "ES-HardDelete:true"
```

### [Response](#tab/tabid-2)

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

***

This changes the general behavior from returning a '404' and recreatable to having the stream now return '410 GONE' forever.

### [Request](#tab/tabid-1)

```bash
curl -i http://127.0.0.1:2113/streams/foo2
```

### [Response](#tab/tabid-2)


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

***