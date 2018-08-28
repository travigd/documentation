---
outputFileName: index.html
---

# Stream Metadata

Every stream in Event Store has metadata associated with it. Internally, the metadata includes information such as the ACL of the stream, the maximum count and age for the events in the stream. Client code can also add information into stream metadata for use with projections or the client API.

A common use case is to store information associated with an event that is not part of the event.

Examples of this are:

-   Which user wrote the event.
-   Which application server were they talking to.
-   What IP address did the request come from?

Stream metadata is stored internally as JSON, and you can access it over the HTTP API.

## Reading Stream Metadata

To read the metadata, issue a `GET` request to the attached metadata resource, which is typically of the form:

```http
http://{eventstore-ip-address}/streams/{stream-name}/metadata
```

You should not access metadata by constructing this URL yourself, as the right to change the resource address is reserved. Instead, you should follow the link from the stream itself, which enables your client to tolerate future changes to the addressing structure.

### [Request](#tab/tabid-1)

[!code-bash[http-api-read-metadata-request](~/code-examples/http-api/read-metadata.sh?start=1&end=1)]

### [Response](#tab/tabid-2)

[!code-json[http-api-read-metadata-response](~/code-examples/http-api/read-metadata.sh?range=3-46,123-)]

* * *

Once you have the URI of the metadata stream, a issue `GET` request to retrieve the metadata:

### [Request](#tab/tabid-3)

```bash
curl -i http://127.0.0.1:2113/streams/$users/metadata --user admin:changeit
```

### [Response](#tab/tabid-4)

<!-- TODO: Incorrect -->

```http
HTTP/1.1 200 OK
Cache-Control: max-age=31536000, public
Content-Length: 652
Content-Type: application/vnd.eventstore.atom+json; charset: utf-8
Vary: Accept
Server: Microsoft-HTTPAPI/2.0
Access-Control-Allow-Methods: GET, POST, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER
Access-Control-Allow-Origin: *
Date: Sun, 16 Jun 2013 13:18:29 GMT

{
  "title": "0@$$$users",
  "id": "<http://127.0.0.1:2113/streams/%24%24%24users/0">,
  "updated": "2013-06-16T12:25:13.8428624Z",
  "author": {
    "name": "EventStore"
  },
  "summary": "$metadata",
  "content": {
    "eventStreamId": "$$$users",
    "eventNumber": 0,
    "eventType": "$metadata",
    "data": {
      "readRole": "$all",
      "metaReadRole": "$all"
    },
    "metadata": ""
  },
  "links": [
    {
      "uri": "http://127.0.0.1:2113/streams/%24%24%24users/0",
      "relation": "edit"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/%24%24%24users/0",
      "relation": "alternate"
    }
  ]
}
```

* * *

If you have security enabled, reading metadata may require that you pass credentials, as in the examples above. If credentials are required and you do not pass them, then you receive a '401 Unauthorized' response.

### [Request](#tab/tabid-5)

[!code-bash[http-api-missing-credentials-request](~/code-examples/http-api/missing-credentials.sh?start=1&end=1)]

### [Response](#tab/tabid-6)

[!code-json[http-api-missing-credentials-response](~/code-examples/http-api/missing-credentials.sh?range=3-)]

* * *

## Writing Metadata

To update the metadata for a stream, issue a `POST` request to the metadata resource.

Inside a file named _metadata.json_:

[!code-json[http-api-metadata-json](~/code-examples/http-api/metadata.json)]

You can also add user-specified metadata here. Some examples user-specified metadata are:

-   Which adapter populates a stream.
-   Which projection created a stream.
-   A correlation ID to a business process.

You then post this information is then posted to the stream:

### [Request](#tab/tabid-7)

[!code-bash[http-api-update-metadata-request](~/code-examples/http-api/update-metadata.sh?start=1&end=1)]

### [Response](#tab/tabid-8)

[!code-json[http-api-update-metadata-response](~/code-examples/http-api/update-metadata.sh?range=3-)]

* * *

If the specified user does not have permissions to write to the stream metadata, you receive a '401 Unauthorized' response.