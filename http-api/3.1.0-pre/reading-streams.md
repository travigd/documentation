---
title: "Reading Streams"
section: "HTTP API"
version: "3.1.0 (pre-release)"
---

Reading from streams with AtomPub can be a bit confusing if you have not done it before but we will go through in this document how reading works. Luckily for many environments the AtomPub protocol has already been implemented!

The Event Store is compliant with the [Atom 1.0 Specification] (http://tools.ietf.org/html/rfc4287) as such many other systems have built in support for the Event Store.

<span class="note--warning">
Being listed or not listed here by no means shows our official support for any of these. We haven’t actually tested or endorsed any of these libraries!
</span>

## Existing Implementations

| Library     | Description                                                                                          |
| ----------- | ---------------------------------------------------------------------------------------------------- |
| NET (BCL)   | `System.ServiceModel.SyndicationServices`                                                            |
| JVM         | [http://java-source.net/open-source/rss-rdf-tools](http://java-source.net/open-source/rss-rdf-tools) |
| PHP         | [http://simplepie.org/](http://simplepie.org/)                                                       |
| Ruby        | [http://simple-rss.rubyforge.org](http://simple-rss.rubyforge.org)                                   |
| Clojure     | [https://github.com/scsibug/feedparser-clj](https://github.com/scsibug/feedparser-clj)               |
| Go          | [https://github.com/jteeuwen/go-pkg-rss](https://github.com/jteeuwen/go-pkg-rss)                     |
| Python      | [http://code.google.com/p/feedparser/](http://code.google.com/p/feedparser/)                         |
| node.js     | [https://github.com/danmactough/node-feedparser](https://github.com/danmactough/node-feedparser)     |
| Objective C | [https://geekli.st/darvin/repos/MWFeedParser](https://geekli.st/darvin/repos/MWFeedParser)           |

<span class="note">
Feel free to add more!
</span>

## A Simple Read

The first thing to learn about an AtomFeed is to do a simple read. The stream will be exposed as a resource located at http(s)://yourdomain.com:port/streams/{stream}. If you do a simple GET to this resource you will get a standard AtomFeed document.

```
ouro@ouroboros:~$ curl -i -H "Accept:application/atom+xml" "http://127.0.0.1:2113/streams/newstream"
```

```http
HTTP/1.1 200 OK
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER
Access-Control-Allow-Origin: *
Cache-Control: max-age=0, no-cache, must-revalidate
Vary: Accept
ETag: "0;-1296467268"
Content-Type: application/atom+xml; charset: utf-8
Server: Mono-HTTPAPI/1.0
Date: Sat, 29 Jun 2013 18:02:21 GMT
Content-Length: 998
Keep-Alive: timeout=15,max=100
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
   <title>Event stream 'newstream'</title>
   <id>http://127.0.0.1:2113/streams/newstream</id>
   <updated>2013-06-29T14:45:06.550308Z</updated>
   <author>
      <name>EventStore</name>
   </author>
   <link href="http://127.0.0.1:2113/streams/newstream" rel="self" />
   <link href="http://127.0.0.1:2113/streams/newstream/head/backward/20" rel="first" />
   <link href="http://127.0.0.1:2113/streams/newstream/0/forward/20" rel="last" />
   <link href="http://127.0.0.1:2113/streams/newstream/1/forward/20" rel="previous" />
   <link href="http://127.0.0.1:2113/streams/newstream/metadata" rel="metadata" />
   <entry>
      <title>0@newstream</title>
      <id>http://127.0.0.1:2113/streams/newstream/0</id>
      <updated>2013-06-29T14:45:06.550308Z</updated>
      <author>
         <name>EventStore</name>
      </author>
      <summary>event-type</summary>
      <link href="http://127.0.0.1:2113/streams/newstream/0" rel="edit" />
      <link href="http://127.0.0.1:2113/streams/newstream/0" rel="alternate" />
   </entry>
</feed>
```

There some important bits to notice here. The Feed here has one item in it. The newest items are always first going to the oldest items. For each entry there are a series of links. These links are links to the events themselves though the events can also be embedded using the `?embed` parameter provided you are requesting JSON. To get an event follow the alternate link and set your Accept headers to the mime type you would like to get the event in.

```
ouro@ouroboros:~/src/EventStore.wiki$ curl -i http://127.0.0.1:2113/streams/newstream/0 -H "Accept: application/json"
```

```http
HTTP/1.1 200 OK
Access-Control-Allow-Methods: GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER
Access-Control-Allow-Origin: *
Cache-Control: max-age=31536000, public
Vary: Accept
Content-Type: application/json; charset: utf-8
Server: Mono-HTTPAPI/1.0
Date: Sat, 29 Jun 2013 18:05:40 GMT
Content-Length: 43
Keep-Alive: timeout=15,max=100

{
  "MyEvent": {
    "Something": "1"
  }
}
```

or for XML

```
ouro@ouroboros:~/src/EventStore.wiki$ curl -i http://127.0.0.1:2113/streams/newstream/0 -H "Accept: application/xml"
```

```http
HTTP/1.1 200 OK
Access-Control-Allow-Methods: GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER
Access-Control-Allow-Origin: *
Cache-Control: max-age=31536000, public
Vary: Accept
Content-Type: application/xml; charset: utf-8
Server: Mono-HTTPAPI/1.0
Date: Sat, 29 Jun 2013 18:06:21 GMT
Content-Length: 56
Keep-Alive: timeout=15,max=100

<data>
   <MyEvent>
      <Something>1</Something>
   </MyEvent>
</data>
```

If I wanted to get the events for this feed I would go to each entry and follow the link to the event. You can either select based on the alternate through media type or you can 

## Feed Paging

The next thing towards understanding how to read a stream is understanding the first/last/previous/next links that are given within a stream. These links conform to http://www.w3.org/TR/1999/REC-html401-19991224/types.html#type-links. The basic idea is that the server will give you links so that you can walk through a stream.

To read through the stream we will follow the pattern defined in RFC 5005 http://tools.ietf.org/html/rfc5005.

In the example above the server had returned as part of its result:

```xml
   <link href="http://127.0.0.1:2113/streams/newstream" rel="self" />
   <link href="http://127.0.0.1:2113/streams/newstream/head/backward/20" rel="first" />
   <link href="http://127.0.0.1:2113/streams/newstream/0/forward/20" rel="last" />
   <link href="http://127.0.0.1:2113/streams/newstream/1/forward/20" rel="previous" />
   <link href="http://127.0.0.1:2113/streams/newstream/metadata" rel="metadata" />
```

This is saying that there is not a next `rel` URL (this means all the information is in this request). It is also saying that this URL is the first link. When dealing with these urls there are two ways of reading the data in the stream. You can either go to the last link and then move forward following prev or you can go to the first link and follow the next links.  The last item will not have a next `rel` link.

If you want to follow a live stream then you would keep following the prev links. When you reach the end (current portion) of a stream you will receive an empty document that does not have entries (or a prev `rel` link). You should then continue polling this URI (in the future a document will appear here). This can be seen by trying the previous link from the above feed.

```
ouro@ouroboros:~/src/EventStore.wiki$ curl -i http://127.0.0.1:2113/streams/newstream/1/forward/20
```

```http
HTTP/1.1 200 OK
Access-Control-Allow-Methods: GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER
Access-Control-Allow-Origin: *
Cache-Control: max-age=0, no-cache, must-revalidate
Vary: Accept
ETag: "0;248368668"
Content-Type: application/vnd.eventstore.atom+json; charset: utf-8
Server: Mono-HTTPAPI/1.0
Date: Sat, 29 Jun 2013 18:12:58 GMT
Content-Length: 762
Keep-Alive: timeout=15,max=100

{
  "title": "Event stream 'newstream'",
  "id": "http://127.0.0.1:2113/streams/newstream",
  "updated": "0001-01-01T00:00:00Z",
  "streamId": "newstream",
  "author": {
    "name": "EventStore"
  },
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
      "uri": "http://127.0.0.1:2113/streams/newstream/0/forward/20",
      "relation": "last"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/newstream/0/backward/20",
      "relation": "next"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/newstream/metadata",
      "relation": "metadata"
    }
  ],
  "entries": []
}
```

When parsing an atom subscription the IDs of events will always stay the same. This is important for figuring out when things are pointing to the same event.

While the simple example above is easy to look at, let’s try an example with more than a single page in it. If you want to do this yourself you can use the testclient that comes with event store and use the `VERIFY` command that will make some fake banking data. After running this command you should find many streams such as `http://127.0.0.1:2113/streams/account-28` in the system.

Going to the link `http://127.0.0.1:2113/streams/account-28` will return us:

```
ouro@ouroboros:~$ curl -v http://127.0.0.1:2113/streams/account-28
```

```html
GET /streams/account-28 HTTP/1.1
User-Agent: curl/7.22.0 (x86_64-pc-linux-gnu) libcurl/7.22.0 OpenSSL/1.0.1 zlib/1.2.3.4 libidn/1.23 librtmp/2.3
Host: 127.0.0.1:2113
Accept: */*

HTTP/1.1 200 OK
Access-Control-Allow-Methods: DELETE, GET, POST, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER
Access-Control-Allow-Origin: *
Cache-Control: max-age=0, no-cache, must-revalidate
Vary: Accept
ETag: "644;248368668"
Content-Type: application/vnd.eventstore.atom+json; charset: utf-8
Server: Mono-HTTPAPI/1.0
Date: Thu, 04 Apr 2013 10:21:20 GMT
Content-Length: 18093
Keep-Alive: timeout=15,max=100
```

```json
{
  "title": "Event stream 'account-28'",
  "id": "http://127.0.0.1:2113/streams/account-28",
  "updated": "2013-04-04T07:20:28.893907Z",
  "author": {
    "name": "EventStore"
  },
  "headOfStream": true,
  "selfUrl": "http://127.0.0.1:2113/streams/account-28",
  "eTag": "644;-43840953",
  "links": [
    {
      "uri": "http://127.0.0.1:2113/streams/account-28",
      "relation": "self"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/account-28",
      "relation": "first"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/account-28/range/19/20",
      "relation": "last"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/account-28/range/664/20",
      "relation": "previous"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/account-28/range/624/20",
      "relation": "next"
    }
  ],
  "entries": <SNIP>
```

Using the `rel` links in this response it is possible to walk through all of the events in the stream either by going to the “last” URL and walking prev or by walking next from the “first” link.

If you go to the “last” `rel` link you will receive:

```
curl -v http://127.0.0.1:2113/streams/account-28/range/19/20
```

```http
GET /streams/account-28/range/19/20 HTTP/1.1
User-Agent: curl/7.22.0 (x86_64-pc-linux-gnu) libcurl/7.22.0 OpenSSL/1.0.1 zlib/1.2.3.4 libidn/1.23 librtmp/2.3
Host: 127.0.0.1:2113
Accept: */*
 
HTTP/1.1 200 OK
Access-Control-Allow-Methods: GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER
Access-Control-Allow-Origin: *
Cache-Control: max-age=31536000, public
Vary: Accept
Content-Type: application/vnd.eventstore.atom+json; charset: utf-8
Server: Mono-HTTPAPI/1.0
Date: Thu, 04 Apr 2013 10:27:50 GMT
Content-Length: 17784
Keep-Alive: timeout=15,max=100
```

```json
{
  "title": "Event stream 'account-28'",
  "id": "http://127.0.0.1:2113/streams/account-28",
  "updated": "2013-04-04T07:19:41.79168Z",
  "author": {
    "name": "EventStore"
  },
  "headOfStream": false,
  "selfUrl": "http://127.0.0.1:2113/streams/account-28",
  "links": [
    {
      "uri": "http://127.0.0.1:2113/streams/account-28",
      "relation": "self"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/account-28",
      "relation": "first"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/account-28/range/19/20",
      "relation": "last"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/account-28/range/39/20",
      "relation": "previous"
    }
  ],
  "entries": [ <SNIP>
```

You would then follow its “previous” link until you got back to the head of the document. This is the general way of reading back a stream. Once at the end you can continue reading events as they happen by polling the previous link and you will get events in near real time as they happen.

It is also important to note that all links with the exception of the head link are fully cachable as seen in the HTTP header `Cache-Control: max-age=31536000, public`. This is very important when discussing intermediaries and performance as if you commonly replay a stream it probably is coming off of your hard drive.

It is also important to note that you should **never** bookmark links aside from the head of the stream resource. You should always be following links to get to things. We may in the future change how our internal linkings are working. If you bookmark things other than the head you will break in these scenarios.

## Reading All Events

There is a special paged feed for all events that is named `$all`. The same paged form of reading described above can be used to read all events for the entire node by pointing the stream at `/streams/$all`. As it is just a stream in the system, all other things can be done with it (e.g. headers/embed body/etc). You are not however allowed to post to this stream.

```
ouro@ouroboros:~/src/retrospective/research/stupidmono$ curl -i http://127.0.0.:2113/streams/%24all
```

```http
HTTP/1.1 200 OK
Access-Control-Allow-Methods: POST, DELETE, GET, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER
Access-Control-Allow-Origin: *
Cache-Control: max-age=0, no-cache, must-revalidate
Vary: Accept
ETag: "26260;248368668"
Content-Type: application/vnd.eventstore.atom+json; charset: utf-8
Server: Mono-HTTPAPI/1.0
Date: Sun, 30 Jun 2013 15:28:56 GMT
Content-Length: 10000
Keep-Alive: timeout=15,max=100
```

```json
{
  "title": "All events",
  "id": "http://127.0.0.1:2113/streams/%24all",
  "updated": "2013-06-30T12:28:47.022528Z",
  "author": {
    "name": "EventStore"
  },
  "links": [
    {
      "uri": "http://127.0.0.1:2113/streams/%24all",
      "relation": "self"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/%24all/head/backward/20",
      "relation": "first"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/%24all/00000000000000000000000000000000/forward/20",
      "relation": "last"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/%24all/000000000000669400000000000066D2/forward/20",
      "relation": "previous"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/%24all/metadata",
      "relation": "metadata"
    }
  ],
  "entries": [
    //snip
]
```

## Conditional Gets

The head link also supports conditional gets through the use of ETAGS. The use of ETAGS is a well known HTTP construct described [here](http://en.wikipedia.org/wiki/HTTP_ETag). The basic idea is that you can include the ETAG of your last request and issue a conditional `get` to the server. If nothing has changed it will not return the full feed. As an example consider we make the request:

```
ouro@ouroboros:~/src/EventStore.wiki$  curl -v http://127.0.0.1:2113/streams/newstream
```

```http
GET /streams/newstream HTTP/1.1
User-Agent: curl/7.22.0 (x86_64-pc-linux-gnu) libcurl/7.22.0 OpenSSL/1.0.1 zlib/1.2.3.4 libidn/1.23 librtmp/2.3
Host: 127.0.0.1:2113
Accept: */*
If-None-Match: "2;-43840953"

HTTP/1.1 200 OK
Access-Control-Allow-Methods: DELETE, GET, POST, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER
Access-Control-Allow-Origin: *
Cache-Control: max-age=0, no-cache, must-revalidate
Vary: Accept
ETag: "2;248368668"
Content-Type: application/vnd.eventstore.atom+json; charset: utf-8
Server: Mono-HTTPAPI/1.0
Date: Wed, 03 Apr 2013 21:33:00 GMT
Content-Length: 3248
Keep-Alive: timeout=15,max=100

//clipped
```

The server has told us in the headers that the ETag for this content is `ETag: "2;248368668"`. We can use this in our next request if we are polling the stream for changes. We will put it in the header If-None-Match. This tells the server to check if the response will be the one we already know. 

```
ouro@ouroboros:~/src/EventStore.wiki$  curl -v --header 'If-None-Match: "2;248368668"
```

```http
http://127.0.0.1:2113/streams/newstream
GET /streams/newstream HTTP/1.1
User-Agent: curl/7.22.0 (x86_64-pc-linux-gnu) libcurl/7.22.0 OpenSSL/1.0.1 zlib/1.2.3.4 libidn/1.23 librtmp/2.3
Host: 127.0.0.1:2113
Accept: */*
If-None-Match: ""2;248368668"

HTTP/1.1 304 Not Modified
Access-Control-Allow-Methods: DELETE, GET, POST, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER
Access-Control-Allow-Origin: *
Content-Type: ; charset: utf-8
Server: Mono-HTTPAPI/1.0
Date: Wed, 03 Apr 2013 21:33:25 GMT
Content-Length: 0
Keep-Alive: timeout=15,max=100
```

When we do the conditional GET we will be returned a 304 not modified. If however the tags have changed it will be returned as normal. This can optimize not sending large streams over the wire if there have not been changes to the stream.

<span class="note">
Etags are created using the version of the stream and the media type you are reading the stream in. You can NOT take an etag from a stream in one media type and use it with another media type.
</span>

## Embedding Data into Stream

Up until now the feeds that have come down have contained links that point back to the actual event data. This is normally a preferable mechanism for a few reasons. The first is that they can be in a different media type than the feed and can be negotiated separately than the feed itself (e.g. feed in JSON event in XML). They can also be cached separately from the feed and can be pointed to by many feeds (if you use a `linkTo()` in projections this is actually what happens in your atom feeds). You can however also tell the atom feeds to embed your events into the stream as opposed to providing links. This can help cut down on the number of requests in some situations but the messages will be larger. Embedding is only supported in JSON.

Though these are mostly used by the StreamUI component in the webapi at present there are ways of embedding events and/or further metadata into your stream that are controlled by the `embed=` parameter.

### Rich

The Rich embed mode will return more properties about the event (eventtype, streamid, position, etc) as can be seen in the following request.

```
ouro@ouroboros:~/src/EventStore.wiki$ curl -i http://127.0.0.1:2113/streams/newstream?embed=rich
```

```http
HTTP/1.1 200 OK
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER
Access-Control-Allow-Origin: *
Cache-Control: max-age=0, no-cache, must-revalidate
Vary: Accept
ETag: "0;248368668"
Content-Type: application/vnd.eventstore.atom+json; charset: utf-8
Server: Mono-HTTPAPI/1.0
Date: Sat, 29 Jun 2013 18:18:22 GMT
Content-Length: 1501
Keep-Alive: timeout=15,max=100
```

```json
{
  "title": "Event stream 'newstream'",
  "id": "http://127.0.0.1:2113/streams/newstream",
  "updated": "2013-06-29T15:12:53.570125Z",
  "streamId": "newstream",
  "author": {
    "name": "EventStore"
  },
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
      "uri": "http://127.0.0.1:2113/streams/newstream/0/forward/20",
      "relation": "last"
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
      "eventType": "event-type",
      "eventNumber": 0,
      "streamId": "newstream",
      "isJson": true,
      "isMetaData": false,
      "isLinkMetaData": false,
      "positionEventNumber": 0,
      "positionStreamId": "newstream",
      "title": "0@newstream",
      "id": "http://127.0.0.1:2113/streams/newstream/0",
      "updated": "2013-06-29T15:12:53.570125Z",
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

### Body

The body embed parameter will put the JSON/XML body of the events into the feed as well depending on the type of the feed. This can be seen in the following HTTP request (note the field “data” that is added).

```
ouro@ouroboros:~/src/retrospective/research/stupidmono$ curl -i http://127.0.0.1:2113/streams/aaa?embed=body
```

```http
HTTP/1.1 200 OK
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER
Access-Control-Allow-Origin: *
Cache-Control: max-age=0, no-cache, must-revalidate
Vary: Accept
ETag: "1;248368668"
Content-Type: application/vnd.eventstore.atom+json; charset: utf-8
Server: Mono-HTTPAPI/1.0
Date: Mon, 01 Jul 2013 14:43:27 GMT
Content-Length: 2184
Keep-Alive: timeout=15,max=100
```

```json
{
  "title": "Event stream 'aaa'",
  "id": "http://127.0.0.1:2113/streams/aaa",
  "updated": "2013-07-01T11:43:21.129594Z",
  "streamId": "aaa",
  "author": {
    "name": "EventStore"
  },
  "links": [
    {
      "uri": "http://127.0.0.1:2113/streams/aaa",
      "relation": "self"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/aaa/head/backward/20",
      "relation": "first"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/aaa/0/forward/20",
      "relation": "last"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/aaa/2/forward/20",
      "relation": "previous"
    },
    {
      "uri": "http://127.0.0.1:2113/streams/aaa/metadata",
      "relation": "metadata"
    }
  ],
  "entries": [
    {
      "eventType": "event-type",
      "eventNumber": 1,
      "data": "{\n  \"a\": \"1\"\n}",
      "streamId": "aaa",
      "isJson": true,
      "isMetaData": false,
      "isLinkMetaData": false,
      "positionEventNumber": 1,
      "positionStreamId": "aaa",
      "title": "1@aaa",
      "id": "http://127.0.0.1:2113/streams/aaa/1",
      "updated": "2013-07-01T11:43:21.129594Z",
      "author": {
        "name": "EventStore"
      },
      "summary": "event-type",
      "links": [
        {
          "uri": "http://127.0.0.1:2113/streams/aaa/1",
          "relation": "edit"
        },
        {
          "uri": "http://127.0.0.1:2113/streams/aaa/1",
          "relation": "alternate"
        }
      ]
    },
    {
      "eventType": "event-type",
      "eventNumber": 0,
      "data": "{\n  \"a\": \"1\"\n}",
      "streamId": "aaa",
      "isJson": true,
      "isMetaData": false,
      "isLinkMetaData": false,
      "positionEventNumber": 0,
      "positionStreamId": "aaa",
      "title": "0@aaa",
      "id": "http://127.0.0.1:2113/streams/aaa/0",
      "updated": "2013-07-01T11:43:21.129559Z",
      "author": {
        "name": "EventStore"
      },
      "summary": "event-type",
      "links": [
        {
          "uri": "http://127.0.0.1:2113/streams/aaa/0",
          "relation": "edit"
        },
        {
          "uri": "http://127.0.0.1:2113/streams/aaa/0",
          "relation": "alternate"
        }
      ]
    }
  ]
}
```

or in XML

```http
ouro@ouroboros:~/src/EventStore.wiki$ curl -i http://127.0.0.1:2113/streams/newstream?embed=body -H "Accept: application/atom+xml"
HTTP/1.1 200 OK
Access-Control-Allow-Methods: POST, DELETE, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER
Access-Control-Allow-Origin: *
Cache-Control: max-age=0, no-cache, must-revalidate
Vary: Accept
ETag: "0;-1296467268"
Content-Type: application/atom+xml; charset: utf-8
Server: Mono-HTTPAPI/1.0
Date: Sat, 29 Jun 2013 18:20:25 GMT
Content-Length: 998
Keep-Alive: timeout=15,max=100
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
   <title>Event stream 'newstream'</title>
   <id>http://127.0.0.1:2113/streams/newstream</id>
   <updated>2013-06-29T15:12:53.570125Z</updated>
   <author>
      <name>EventStore</name>
   </author>
   <link href="http://127.0.0.1:2113/streams/newstream" rel="self" />
   <link href="http://127.0.0.1:2113/streams/newstream/head/backward/20" rel="first" />
   <link href="http://127.0.0.1:2113/streams/newstream/0/forward/20" rel="last" />
   <link href="http://127.0.0.1:2113/streams/newstream/1/forward/20" rel="previous" />
   <link href="http://127.0.0.1:2113/streams/newstream/metadata" rel="metadata" />
   <entry>
      <title>0@newstream</title>
      <id>http://127.0.0.1:2113/streams/newstream/0</id>
      <updated>2013-06-29T15:12:53.570125Z</updated>
      <author>
         <name>EventStore</name>
      </author>
      <summary>event-type</summary>
      <link href="http://127.0.0.1:2113/streams/newstream/0" rel="edit" />
      <link href="http://127.0.0.1:2113/streams/newstream/0" rel="alternate" />
   </entry>
</feed>
```
There are two other modes are just variants of body. There is PrettyBody which will try to reformat the JSON to make it “pretty to read” and there is TryHarder that will work even harder to try to parse and reformat JSON from an event to allow it to be returned in the feed. These do not however include further information, they are focused on what the feed looks like. 

## Deleted Stream

If a stream has been deleted and you try to read from the head of the stream you will receive a 410 Deleted as shown. This is partly why reading head links is so important, if handling a re-read of the stream and you have bits cached.

```
ouro@ouroboros:~$ curl -i -H "Accept:application/atom+xml" "http://127.0.0.1:2113/streams/astream"
```

```http
HTTP/1.1 410 Deleted
Access-Control-Allow-Methods: DELETE, GET, POST, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER
Access-Control-Allow-Origin: *
Content-Type: ; charset: utf-8
Server: Mono-HTTPAPI/1.0
Date: Wed, 03 Apr 2013 17:25:04 GMT
Content-Length: 0
Keep-Alive: timeout=15,max=100
```