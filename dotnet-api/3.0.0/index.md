---
title: "Overview"
section: ".NET API"
version: 3.0.0
pinned: true
---

The .NET Client API communicates with the Event Store using over TCP, using length-prefixed serialized protocol buffers. The API allows for reading and writing operations, as well as for subscriptions to individual event streams or all events written.

## Quick Start

The code below shows how to connect to an Event Store server, write to a stream, and read back the events. For more detailed information, read the full pages for [Connecting to a Server](./connecting-to-a-server/), [Reading Specific Streams](./reading-streams/) and [Writing to a Stream](./writing-to-a-stream/)

```CSharp
var connection = 
    EventStoreConnection.Create(new IPEndPoint(IPAddress.Loopback, 1113));

// Don't forget to tell the connection to connect!
connection.ConnectAsync().Wait();

var myEvent = new EventData(Guid.NewGuid(), "testEvent", false,
                            Encoding.UTF8.GetBytes("some data"),
                            Encoding.UTF8.GetBytes("some metadata"));

connection.AppendToStreamAsync("test-stream",
                               ExpectedVersion.Any, myEvent).Wait();

var streamEvents = 
    connection.ReadStreamEventsForwardAsync("test-stream", 0, 1, false).Result;

var returnedEvent = streamEvents.Events[0].Event;

Console.WriteLine("Read event with data: {0}, metadata: {1}",
    Encoding.UTF8.GetString(returnedEvent.Data),
    Encoding.UTF8.GetString(returnedEvent.Metadata));
```