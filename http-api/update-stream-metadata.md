# Stream Metadata

<!--  TODO: Break up to write / read? And maybe transclude-->

## Writing Metadata

To update the metadata for a stream, issue a `POST` request to the metadata resource. This will replace the current metadata with the information posted.

Inside a file named _metadata.txt_:

```json
[
    {
        "eventId": "7c314750-05e1-439f-b2eb-f5b0e019be72",
        "eventType": "$user-updated",
        "data": {
            "readRole": "$all",
            "metaReadRole": "$all"
        }
    }
]
```

You can also add user-specified metadata here. Some examples of good uses of user-specified metadata:

-   which adapter is responsible for populating a stream.
-   which projection caused a stream to be created.
-   a correlation ID of some business process.

This information is then posted to the stream:

### [Request](#tab/tabid-7)

```bash
curl -i -d @metadata.txt http://127.0.0.1:2113/streams/$users/metadata --user admin:changeit -H "Content-Type: application/vnd.eventstore.events+json"
```

### [Response](#tab/tabid-8)

```http
HTTP/1.1 201 Created
Content-Length: 0
Content-Type: text/plain; charset: utf-8
Location: http://127.0.0.1:2113/streams/%24%24%24users/1
Server: Microsoft-HTTPAPI/2.0
Access-Control-Allow-Methods: GET, POST, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER
Access-Control-Allow-Origin: *
Date: Sun, 16 Jun 2013 14:50:21 GMT
```

* * *

If the specified user does not have permissions to write to the stream metadata, you will receive a '401 Unauthorized' response:

### [Request](#tab/tabid-9)

```bash
curl -i -d @metadata.txt http://127.0.0.1:2113/streams/$users/metadata --user invaliduser:invalidpass -H "Content-Type: application/vnd.eventstore.events+json"
```

### [Response](#tab/tabid-10)

```http
HTTP/1.1 401 Unauthorized
Content-Length: 0
Server: Microsoft-HTTPAPI/2.0
Access-Control-Allow-Methods:
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER
Access-Control-Allow-Origin: *
WWW-Authenticate: Basic realm="ES"
Date: Sun, 16 Jun 2013 14:51:37 GMT
```

* * *
