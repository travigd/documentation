---
title: "Getting Started"
section: "Introduction"
pinned: true
version: "4.0.2"
---

This guide will show you how to get started with Event Store using the Atom publishing protocol as the primary interface. It covers installation and basic operations such as writing to a stream, reading from a stream, and subscribing to a stream.

<span class="note--warning">
The described is for development and evaluation of Event Store. It does not describe a production setup.
</span>

## Install and Run

<div class="codetabs" markdown="1">
<div data-lang="windows" markdown="1">
The prerequisites for Installing on Windows are:

-   NET Framework 4.0+
-   Windows platform SDK with compilers (v7.1) or Visual C++ installed (Only required for a full build)

Event Store has Chocolatey packages available that you can install with the following command:

```powershell
choco install eventstore-oss
```

You can also [download](https://geteventstore.com/downloads) a binary, unzip the archive and run from the folder location.

Then with an administrator console run the following command:

```powershell
EventStore.ClusterNode.exe --db ./db --log ./logs
```

This will start Event Store with the database stored at the path _./db_ and the logs in _./logs_. You can view further command line arguments in the [server docs](/server/latest).

Event Store is running in an admin context because it will start a HTTP server through `http.sys`. For permanent or production instances you will need to provide an ACL such as:

```powershell
netsh http add urlacl url=http://+:2113/ user=DOMAIN\username
```

</div>
<div data-lang="linux" markdown="1">
The prerequisites for Installing on Linux are:

-   Mono 4.6.2

Event Store has pre-built [packages available for Debian-based distributions](https://packagecloud.io/EventStore/EventStore-OSS), [manual instructions for distributions that use RPM](https://packagecloud.io/EventStore/EventStore-OSS/install#bash-rpm), or you can [build from source](https://github.com/EventStore/EventStore#linux).

If you installed from a pre-built package, start Event Store with:

```bash
sudo service eventstore start
```

Or, in all other cases you can run the Event Store binary or use our run-node shell script which exports the environment variable `LD_LIBRARY_PATH` to include the installation path of Event Store, which is necessary if you are planning to use projections.

```bash
$ ./run-node.sh --db ./ESData
```

</div>
<div data-lang="docker" markdown="1">
Event Store has [a Docker image](https://hub.docker.com/r/eventstore/eventstore/) available for any platform that supports Docker:

```bash
docker run --name eventstore-node -it -p 2113:2113 -p 1113:1113 eventstore/eventstore
```

</div>
</div>

Event Store should now be running at <http://127.0.0.1:2113/> to see the admin console. The console will ask for a username and password. The defaults are `admin:changeit`.

## Writing Events to an Event Stream

Event Store operates on a concept of Event Streams, and the first operation we will look at is how to write to a stream. These are partition points in the system <!-- What does this mean? -->. If you are Event Sourcing a domain model a stream equates to an aggregate function. Event Store can handle hundreds of millions of streams, create as many as you need.

To begin, open a text editor, copy and paste the following event definition, and save it as _event.txt_.

```json
[
  {
    "eventId": "fbf4a1a1-b4a3-4dfe-a01f-ec52c34e16e4",
    "eventType": "event-type",
    "data": {

      "a": "1"
    }
  }
]
```

To write the event to a stream, issue the following cURL command.

```shell
curl -i -d @event.txt "http://127.0.0.1:2113/streams/newstream" -H "Content-Type:application/vnd.eventstore.events+json"
```

<span class="note">
You can also post events as XML, by changing the `Content-Type` header to `XML`.
</span>

This gives the following result:

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

Open the UI after this command to the _Stream Browser_ tab and you will see the stream you created. If you post to a stream that doesn’t exist, Event Store will create it. You can click it to view an HTML representation of your stream.

You can also setup [Access Control Lists](/server/latest/access-control-lists/) on your streams by changing the metadata of the stream.

## Reading From a Stream

Event Store exposes all streams as [atom feeds](http://tools.ietf.org/html/rfc4287), and you can read data from the stream by navigating to the _head_ URI of the stream <http://127.0.0.1:2113/streams/newstream> with cURL.

```shell
curl -i -H "Accept:application/atom+xml" "http://127.0.0.1:2113/streams/newstream"
```

Which gives the following result:

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

<span class="note">
This example uses cURL, but you can read Atom feeds with a wide variety of applications and languages.
</span>

<span class="note">
This command asked Event Store to return the feed in `atom+xml` format, you can also use `application/vnd.eventstore.atom+json` if you prefer JSON.
</span>

The feed has a single item inside of it, the one you just posted. You can then get the event by issuing a `GET` to the `alternate` URI value.

```shell
curl -i http://127.0.0.1:2113/streams/newstream/0 -H "Accept: application/json"
```

Which gives the following response:

```http
HTTP/1.1 200 OK
Access-Control-Allow-Methods: GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Requested-With, X-PINGOTHER
Access-Control-Allow-Origin: *
Cache-Control: max-age=31536000, public
Vary: Accept
Content-Type: application/json; charset: utf-8
Server: Mono-HTTPAPI/1.0
Date: Wed, 03 Jul 2013 11:09:12 GMT
Content-Length: 14
Keep-Alive: timeout=15,max=100

{
  "a": "1"
}
```

<span class="note">
You can also use `Accept: text/xml` if you prefer XML.
</span>

To read a single page feed, you request the feed and then iterate through the event links by executing `GET` requests. This may feel inefficient at first but remember the event URIs and most of the page URIs are infinitely cachable.

You can also `GET` the events in the feed <!-- Need to understand this better--> itself if by using `?embed=body` in the request. You can find further information on this [here](/http-api/latest/reading-streams).

Sometimes your feed may span more than one atom page, and you will need to paginate through the feed. You do this by following the relation links in the feed. To read a feed from the beginning to the end you would go to the _last_ link and then continue to read the _previous_ page. You can also do more of a twitter style follow and start from now and take the last say 50 to display by using _first_ then _next_.

<!-- Needs an example -->

## Subscribing to Stream to Receive Updates

**Another common operation people want to be able to do is to listen to a stream for when changes are occuring.**

This works the same way as paging through an Atom feed. As new events arrive, new _previous_ links are created and you can continue following them. The example below is in C# and includes both paging and subscribing over time. If you wanted to provide an _at least once_ <!-- What is this? --> assurance with the following code, save the last URI you received.

<div class="codetabs" markdown="1">
<div data-lang="csharp" markdown="1">
```csharp
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.ServiceModel.Syndication; // reference "System.ServiceModel"
using System.Threading;
using System.Xml;

namespace AtomPoller
{
    class Program
    {
        private static SyndicationLink GetNamedLink(IEnumerable<SyndicationLink> links, string name)
        {
            return links.FirstOrDefault(link => link.RelationshipType == name);
        }
        static Uri GetLast(Uri head)
        {
            var request = (HttpWebRequest)WebRequest.Create(head);
            request.Credentials = new NetworkCredential("admin", "changeit");
            request.Accept = "application/atom+xml";
            try
            {
                using (var response = (HttpWebResponse) request.GetResponse())
                {
                    if (response.StatusCode == HttpStatusCode.NotFound)
                        return null;
                    using (var xmlreader = XmlReader.Create(response.GetResponseStream()))
                    {
                        var feed = SyndicationFeed.Load(xmlreader);
                        var last = GetNamedLink(feed.Links, "last");
                        return (last != null) ? last.Uri : GetNamedLink(feed.Links, "self").Uri;
                    }
                }
            }
            catch(WebException ex)
            {
                if (((HttpWebResponse) ex.Response).StatusCode == HttpStatusCode.NotFound) return null;
                throw;
            }
        }

        private static void ProcessItem(SyndicationItem item)
        {
            Console.WriteLine(item.Title.Text);
            //get events
            var request = (HttpWebRequest)WebRequest.Create(GetNamedLink(item.Links, "alternate").Uri);
            request.Credentials = new NetworkCredential("admin", "changeit");
            request.Accept = "application/json";
            using (var response = request.GetResponse())
            {
                var streamReader = new StreamReader(response.GetResponseStream());
                Console.WriteLine(streamReader.ReadToEnd());
            }
        }

        private static Uri ReadPrevious(Uri uri)
        {
            var request = (HttpWebRequest)WebRequest.Create(uri);
            request.Credentials = new NetworkCredential("admin", "changeit");
            request.Accept = "application/atom+xml";
            using(var response = request.GetResponse())
            {
                using(var xmlreader = XmlReader.Create(response.GetResponseStream()))
                {
                    var feed = SyndicationFeed.Load(xmlreader);
                    foreach (var item in feed.Items.Reverse())
                    {
                        ProcessItem(item);
                    }
                    var prev = GetNamedLink(feed.Links, "previous");
                    return prev == null ? uri : prev.Uri;
                }
            }
        }

        private static void PostMessage()
        {
            var message = "[{'eventType':'MyFirstEvent', 'eventId':'"
                + Guid.NewGuid() + "', 'data':{'name':'hello world!', 'number':"
                + new Random().Next() + "}}]";
            var request = WebRequest.Create("http://127.0.0.1:2113/streams/yourstream");
            request.Method = "POST";
            request.ContentType = "application/vnd.eventstore.events+json";
            request.ContentLength = message.Length;
            using(var sw= new StreamWriter(request.GetRequestStream()))
            {
                sw.Write(message);
            }
            using(var response = request.GetResponse())
            {
                response.Close();
            }
        }

        static void Main(string[] args)
        {
            var timer = new Timer(o => PostMessage(), null, 1000, 1000);
            Uri last = null;
            Console.WriteLine("Press any key to exit.");
            var stop = false;
            while (last == null && !stop)
            {
                last = GetLast(new Uri("http://127.0.0.1:2113/streams/yourstream"));
                if(last == null) Thread.Sleep(1000);
                if (Console.KeyAvailable)
                {
                    stop = true;
                }
            }

            while(!stop)
            {
                var current = ReadPrevious(last);
                if(last == current)
                {
                    Thread.Sleep(1000);
                }
                last = current;
                if(Console.KeyAvailable)
                {
                    stop = true;
                }
            }
        }
    }

}

    </div>
    <div data-lang="javascript" markdown="1">
    ```javascript
    if (!window.es) { window.es = {}; };
    es.projection = function (settings) {

        var projectionBody = settings.body;
        var onStateUpdate = settings.onStateUpdate || function () { };
        var showError = settings.showError || function () { };
        var hideError = settings.hideError || function () { };

        var currentTimeout = null;
        var currentAjaxes = null;
        var category = null;

        return {
            start: startProjection,
            stop: stopProjection
        };

        function startProjection() {

            stopProjection();
            var processor = $initialize_hosted_projections();
            projectionBody();
            processor.initialize();

            var sources = JSON.parse(processor.get_sources());
            if (sources.all_streams
                || (sources.categories != null && sources.categories.length > 1)
                || (sources.streams != null && sources.streams.length > 1)) {
                throw "Unsupported projection source to run in the web browser";
            }

            if (sources.categories != null && sources.categories.length == 1) {
                category = sources.categories[0];
                startPolling("$ce-" + category, process_event);
            } else {
                category = null;
                startPolling(sources.streams[0], process_event);
            }

            function process_event(event) {
                var parsedEvent = event;

                processor.process_event(parsedEvent.data,
                                parsedEvent.eventStreamId,
                                parsedEvent.eventType,
                                category,
                                parsedEvent.eventNumber,
                                parsedEvent.metadata);
                var stateStr = processor.get_state();
                var stateObj = JSON.parse(stateStr);

                onStateUpdate(stateObj, stateStr);
            }
        };

        function stopProjection() {
            if (currentTimeout !== null)
                clearTimeout(currentTimeout);
            if (currentAjaxes !== null) {
                for (var i = 0, l = currentAjaxes.length; i < l; i++) {
                    currentAjaxes[i].abort();
                }
            }

            currentAjaxes = null;
            currentTimeout = null;
        };

        function startPolling(streamId, callback) {

            var firstPageUrl = '/streams/' + encodeURIComponent(streamId);
            var lastProcessedPageUrl = null;
            var lastProcessedEntry = null;

            // not used yet - when something fails we just retry
            var defaultFail = function(a, b, c) { alert('Failed!'); };

            readAll(null, null);

            function readAll(fromPageUrl, fromEntry) {

                lastProcessedPageUrl = fromPageUrl;
                lastProcessedEntry = fromEntry;

                readFirstPage({
                    pageRead: pageRead,
                    noEntries: noEntries,
                    fail: defaultFail
                });

                function pageRead(firstPageUrl, lastEntry) {

                    // check for end of stream
                    if (lastProcessedEntry !== null && Entry.isNewerOrSame(lastProcessedEntry, lastEntry)) {
                        delayedReadAll(lastProcessedPageUrl, lastProcessedEntry);
                        return;
                    }

                    readRange({
                        page: fromPageUrl || firstPageUrl,
                        from: fromEntry || null,
                        to: lastEntry,
                        processEvent: callback,
                        endOfStream: delayedReadAll,
                        success: function (lastReadPageUrl, lastReadEntry) { readAll(lastReadPageUrl, lastReadEntry); },
                        fail: defaultFail
                    });
                }

                function noEntries() {
                    delayedReadAll(lastProcessedPageUrl, lastProcessedEntry);
                }

                function delayedReadAll(page, entry) {
                    setTimeout(function () { readAll(page, entry); }, 1000);
                }
            }

            function readFirstPage(sets) {

                var pageRead = sets.pageRead;
                var noEntries = sets.noEntries;
                var fail = sets.fail;

                $.ajax(firstPageUrl, {
                    headers: {
                        'Accept': 'application/json'
                    },
                    success: function (page) {
                        if (page.entries.length === 0) {
                            noEntries();
                        }
                        var lastEntry = page.entries[0];
                        var lastPage = $.grep(page.links, function (link) { return link.relation === 'last'; })[0].uri;
                        pageRead(lastPage, lastEntry);
                    },
                    error: function (jqXhr, status, error) {
                        setTimeout(function () { readFirstPage(sets); }, 1000);
                        //fail.apply(window, arguments);
                    }
                });
            }

            function readRange(sets) {

                var page = sets.page;
                var from = sets.from;
                var to = sets.to;
                var processEvent = sets.processEvent;
                var success = sets.success;
                var fail = sets.fail;

                readByPages(page);

                function readByPages(fromPage) {
                    readPage({
                        url: fromPage,
                        lowerBound: from,
                        upperBound: to,
                        processEvent: processEvent,
                        onPageRead: function (nextPage) {
                            readByPages(nextPage);
                        },
                        onUpperBound: function (lastReadPageUrl, lastReadEntry) {
                            success(lastReadPageUrl, lastReadEntry);
                        },
                        fail: fail
                    });
                }
            }

            function readPage(sets) {

                var pageUrl = sets.url;
                var fromEntry = sets.lowerBound;
                var toEntry = sets.upperBound;
                var processEvent = sets.processEvent;
                var onPageRead = sets.onPageRead;
                var onUpperBound = sets.onUpperBound;
                var fail = sets.fail;

                $.ajax(pageUrl, {
                    headers: {
                        'Accept': 'application/json'
                    },
                    success: function (page) {
                        var nextPage = $.grep(page.links, function (link) { return link.relation === 'previous'; })[0].uri;
                        var entries = $.grep(page.entries, function (entry) {
                            // if we've read more entries then we were asked to - it's ok - just set lastEntry correctly
                            return fromEntry === null || Entry.isNewer(entry, fromEntry);
                        });
                        var onEntriesRead = null;

                        if (Entry.isOnPage(pageUrl, toEntry)) {

                            // setting LastEntry as null is ok - readAll will just continue reading from beginning of page. And as deleted events won't appear again - no duplicates will be processed

                            if (entries.length === 0) {
                                onUpperBound(pageUrl, toEntry);
                                return;
                            }

                            var lastEntry = Entry.max(entries);
                            onEntriesRead = function () { onUpperBound(pageUrl, lastEntry); };
                        } else {
                            onEntriesRead = function () { onPageRead(nextPage); };
                        }

                        if (entries.length === 0) {
                            onPageRead(nextPage); // probably was deleted by maxAge/maxCount
                            return;
                        }

                        getEvents(entries, processEvent, onEntriesRead);
                    },
                    error: function () {
                        setTimeout(function () { readPage(sets); }, 1000);
                    }
                });



                function getEvents(entries, processEvent, onFinish) {

                    var eventsUrls = $.map(entries, function (entry) {
                        var jsonLink = $.grep(entry.links, function (link) { return link.type === 'application/json'; })[0].uri;
                        return jsonLink;
                    });

                    var eventsUrlsCount = eventsUrls.length;
                    var processedEventUrlsCount = 0;
                    var receivedEvents = [];

                    currentAjaxes = [];

                    for (var i = 0; i < eventsUrlsCount; i++) {
                        var url = eventsUrls[i];
                        var ajax = $.ajax(url, {
                            headers: {
                                "Accept": "application/json"
                            },
                            dataType: 'json',
                            success: successFeed,
                            error: errorFeed
                        });
                        currentAjaxes.push(ajax);
                    }

                    function successFeed(data) {
                        receivedEvents.push(data);
                        processBatchItem();
                    }

                    function errorFeed(jqXHR, status, error) {
                        if (jqXHR.responseCode === 404) {
                            // do nothing. entry may have been erased by maxAge/maxCount
                            processBatchItem();
                        } else {
                            // throw 'TODO: consider what to do if server is down or busy'
                        }
                    }

                    function processBatchItem() {
                        processedEventUrlsCount++;

                        if (processedEventUrlsCount === eventsUrlsCount) {
                            currentAjaxes = []; // no easy way to remove ajaxes from array when they arrive, so just remove all when batch done

                            var successfullReads = receivedEvents.length;
                            // can't do much about unsuccessfull reads :\

                            processReceivedEvents(receivedEvents);
                            receivedEvents = null;

                            onFinish();
                        }
                    }

                    function processReceivedEvents(events) {
                        events.sort(function (a, b) {
                            return a.eventNumber - b.eventNumber;
                        });

                        for (var j = 0, l = events.length; j < l; j++) {
                            processEvent(events[j]);
                        }
                    }
                }
            }

            var Entry = {};
            Entry.isNewer = function (entry1, entry2) {
                return Entry.compare(entry1, entry2) > 0;
            };
            Entry.isNewerOrSame = function (entry1, entry2) {
                return Entry.compare(entry1, entry2) >= 0;
            };
            Entry.isOlderOrSame = function (entry1, entry2) {
                return Entry.compare(entry1, entry2) <= 0;
            };
            Entry.compare = function (entry1, entry2) {
                return Entry.getId(entry1) - Entry.getId(entry2);
            };
            Entry.getId = function (entry) {
                var strId = entry.id.substring(entry.id.lastIndexOf("/") + 1, entry.id.length);
                return parseInt(strId);
            };
            Entry.isOnPage = function (pageUrl, entry) {
                var entryId = Entry.getId(entry);

                // example: http://127.0.0.1:2114/streams/$stats-127.0.0.1:2114/range/39/20
                var urlParts = pageUrl.split('/');
                var start = parseInt(urlParts[urlParts.length - 2]); // before last
                var backwardCount = parseInt(urlParts[urlParts.length - 1]); // last

                return entryId > start - backwardCount && entryId <= start;
            };
            Entry.max = function (array) {
                if (array.length === 0)
                    throw 'Cannot get max element in empty array';
                var res = array[0];
                for (var i = 1, l = array.length; i < l; i++) {
                    if (Entry.compare(array[i], res) > 0) {
                        res = array[i];
                    }
                }
                return res;
            };
        }
    };

</div>
</div>
