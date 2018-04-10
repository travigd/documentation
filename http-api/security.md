---
title: "Security"
section: "HTTP API"
version: "4.0.2"
---

Event Store supports security over HTTP. This guide is an introduction to how security is implemented <!-- TODO: Where can you read more? -->.

## Authentication

Event Store supports authentication over basic authentication to internal users. You create these users with the RESTful API or the admin console. Once you have configured users, you can use standard basic authentication on requests.

<span class="note">
You can also use the trusted intermediary header to provide for externalized authentication that can allow you to integrate almost any authentication system with Event Store. Read more about it [the trusted intermediary header here]({{site.baseurl}}/http-api/optional-http-headers/trusted-intermediary).
</span>

As an example if you were to use the default admin user `admin:changeit`, you would include this in you request:

<div class="codetabs" markdown="1">
<div data-lang="request" markdown="1">
```bash
curl -i 'http://127.0.0.1:2113/streams/$all' -u admin:changeit
```
</div>
<div data-lang="response" markdown="1">
```http
HTTP/1.1 200 OK
Access-Control-Allow-Methods: POST, DELETE, GET, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER
Access-Control-Allow-Origin: *
Cache-Control: max-age=0, no-cache, must-revalidate
Vary: Accept
ETag: "28334346;248368668"
Content-Type: application/vnd.eventstore.atom+json; charset: utf-8
Server: Mono-HTTPAPI/1.0
Date: Thu, 04 Jul 2013 00:13:59 GMT
Content-Length: 12212
Keep-Alive: timeout=15,max=100
```
</div>
</div>

If you were to use the wrong user or no user where one is required, you would receive a `401 Unauthorized` response.

<div class="codetabs" markdown="1">
<div data-lang="request" markdown="1">
```bash
curl -i 'http://127.0.0.1:2113/streams/$all' -u admin:password
```
</div>
<div data-lang="response" markdown="1">
```http
HTTP/1.1 401 Unauthorized
Access-Control-Allow-Methods: POST, DELETE, GET, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER
Access-Control-Allow-Origin: *
WWW-Authenticate: Basic realm="ES"
Content-Type: text/plain; charset: utf-8
Server: Mono-HTTPAPI/1.0
Date: Thu, 04 Jul 2013 00:20:34 GMT
Content-Length: 0
Keep-Alive: timeout=15,max=100
```
</div>
</div>

As you pass the username and password as part of the request it is not recommended that you run Event Store over HTTP, you should enable SSL to encrypt the user information. You can find instructions on how to accomplish this in [Windows]({{site.baseurl}}/http-api/setting-up-ssl-in-windows) and [Linux]({{site.baseurl}}/http-api/setting-up-ssl-in-linux). If you are running the clustered version you can also setup SSL for the replication protocol <!-- TODO: Does this need further explanation? -->.

## Access Control Lists

Along with authentication, Event Store supports per stream configuration of Access Control Lists (ACL). To configure the ACL of a stream you should go to its head and look for the metadata relationship link to obtain the metadata for the stream.

```json
{
  "uri": "http://127.0.0.1:2113/streams/%24all/metadata",
  "relation": "metadata"
}
```

To set access control lists over HTTP you can post to the metadata stream as with setting any other metadata. You can also set Access Control Lists for a stream in the web UI.

For more information on the structure of how Access Control Lists work please read [Access Control Lists]({{site.baseurl}}/server/access-control-lists).
