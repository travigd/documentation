# Stream Metadata

<!--  TODO: Break up to write / read? And maybe transclude-->

Every stream in Event Store has metadata associated with it. Internally, the metadata includes information such as the ACL of the stream and the maximum count and age for the events in the stream. Client code can also add information into stream metadata for use with projections or the client API.

A common use case for information you may want to store in metadata is information associated with an event that is not part of the event.

Examples of this might be:

-   Which user wrote the event.
-   Which application server were they talking to.
-   What IP address did the request come from?

Stream metadata is stored internally as JSON, and you can access it over the HTTP APIs.

## Reading Stream Metadata

To read the metadata, issue a `GET` request to the attached metadata resource, which is of the form:

```http
http://{eventstore}/streams/{stream-name}/metadata
```

You should not access metadata by constructing this URL yourself, as the right to change the resource address is reserved. Instead, you should follow the link for from the stream itself, which will enable your client to tolerate future changes to the addressing structure without breaking.

### [Request](#tab/tabid-1)

```bash
curl -i http://127.0.0.1:2113/streams/$users --user admin:changeit
```

### [Response](#tab/tabid-2)

```http
HTTP/1.1 200 OK
Cache-Control: max-age=0, no-cache, must-revalidate
Content-Length: 1267
Content-Type: application/vnd.eventstore.atom+json; charset: utf-8
ETag: "0;-2060438500"
Vary: Accept
Server: Microsoft-HTTPAPI/2.0
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER
Access-Control-Allow-Origin: *
Date: Sun, 16 Jun 2013 15:08:49 GMT

{
  "title": "Event stream '$users'",
  "id": "<http://127.0.0.1:2113/streams/%24users">,
  "updated": "2013-06-16T15:08:47.5245306Z",
  "author": {
    "name": "EventStore"
  },
  "links": [
    {
      "uri": "http://127.0.0.1:2113/streams/%24users",
      "relation": "self"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/%24users/head/backward/20",
      "relation": "first"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/%24users/0/forward/20",
      "relation": "last"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/%24users/1/forward/20",
      "relation": "previous"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/%24users/metadata",
      "relation": "metadata"
    }
  ],
...
```

* * *

Once you have the URI of the metadata stream, a `GET` request will retrieve the metadata:

### [Request](#tab/tabid-3)

```bash
curl -i http://127.0.0.1:2113/streams/$users/metadata --user admin:changeit
```

### [Response](#tab/tabid-4)

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

Reading metadata may require that you pass credentials if you have security enabled, as in the examples above. If you do not pass credentials and they are required you will receive a '401 Unauthorized' response.

### [Request](#tab/tabid-5)

```bash
curl -i http://127.0.0.1:2113/streams/$users/metadata
```

### [Response](#tab/tabid-6)

```http
HTTP/1.1 401 Unauthorized
Content-Length: 0
Content-Type: text/plain; charset: utf-8
Server: Microsoft-HTTPAPI/2.0
Access-Control-Allow-Methods: GET, POST, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER
Access-Control-Allow-Origin: *
WWW-Authenticate: Basic realm="ES"
Date: Sun, 16 Jun 2013 13:20:22 GMT
```

* * *
