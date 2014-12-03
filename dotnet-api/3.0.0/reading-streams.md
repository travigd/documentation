---
title: "Reading Specific Streams"
section: ".NET API"
version: 3.0.0
---

The client API can be used to read events from a stream starting from either end of the stream. There are a pair of methods for each direction, one asynchronous and one blocking. The blocking variants use the asynchronous versions underneath, but block awaiting a result.

## Methods

### Reading a stream forwards

```csharp
Task<StreamEventsSlice> ReadStreamEventsForwardAsync(string stream, int start, int count, bool resolveLinkTos)
```

```csharp
StreamEventsSlice ReadStreamEventsForward(string stream, int start, int count, bool resolveLinkTos)
```

### Reading a stream backwards

```csharp
Task<StreamEventsSlice> ReadStreamEventsBackwardAsync(string stream, int start, int count, bool resolveLinkTos)
```

```csharp
StreamEventsSlice ReadStreamEventsBackward(string stream, int start, int count, bool resolveLinkTos)
```

## StreamEventsSlice

The reading methods for individual streams each return a `StreamEventsSlice`, which are immutable. The available members on StreamEventsSlice are:

- `string Stream` - The name of the stream for the slice.

- `ReadDirection ReadDirection` - Either `ReadDirection.Forward` or `ReadDirection.Backward` depending on which method was used to read.

- `int FromEventNumber` - The sequence number of the first event in the stream.

- `int LastEventNumber` - The sequence number of the last event in the stream.

- `int NextEventNumber` - The sequence number from which the next read should be performed to continue reading the stream.

- `bool IsEndOfStream` - Whether or not this slice contained the end of the stream at the time it was created.

- `ResolvedEvent[] Events` - An array of the events read. See the description of how to interpret a [Resolved Event](wiki/NET-ResolvedEvents) for more information on this.

## Reading a stream forwards

The `ReadStreamEventsForwardAsync` and `ReadStreamEventsForward` methods read the requested number of events in the order in which they were originally written to the stream from a nominated starting point in the stream, working in an async and blocking manner respectively. 

The parameters are:

- `string stream` - The name of the stream to read.

- `int start` - The earliest event to read (inclusive). For the “special cases” of the start of the stream and the first client event, the constants `StreamPosition.Start` and `StreamPosition.FirstClientEvent` should be used respectively in order to protect against a planned future change to how metadata is written (see discussion [here]()).

- `int count` - The maximum number of events to read in this request (assuming that many exist between the start specified and the end of the stream).

- `bool resolveLinkTos` - Determines whether or not any link events encountered in the stream will be resolved. See the discussion on [Resolved Events](wiki/NET-ResolvedEvents) for more information on this.

### Example: Reading an entire stream forwards from start to end

This example uses the synchronous `ReadStreamEventsForward` method in a loop to page through all events in a stream, reading 200 events at a time in order to build a list of all the events in the stream.

*Note: it is unlikely that client code would need to actually build a list in this manner. It is far more likely that events would be passed into a left fold in order to derive the state of some object as of a given event.*

```csharp
var streamEvents = new List&lt;ResolvedEvent&gt;();

StreamEventsSlice currentSlice;
var nextSliceStart = StreamPosition.Start;
do
{
	currentSlice = _eventStoreConnection.ReadStreamEventsForward("myStream", nextSliceStart, 200, false);
	nextSliceStart = currentSlice.NextEventNumber;

	streamEvents.AddRange(currentSlice.Events);
} while (!currentSlice.IsEndOfStream);
```

## Reading a stream backwards

The `ReadStreamEventsBackwardAsync` and `ReadStreamEventsBackward` methods read the requested number of events in the reverse order from that in which they were originally written to the stream from a specified starting point, working in an async and blocking manner respectively.

The parameters are:

- `string stream` - The name of the stream to read.

- `int start` - The latest event to read (inclusive). For the end of the stream use the constant `StreamPosition.End`.

- `int count` - The maximum number of events to read in this request (assuming that many exist between the start specified and the start of the stream).

- `bool resolveLinkTos` - Determines whether or not any link events encountered in the stream will be resolved. See the discussion on [Resolved Events](wiki/NET-ResolvedEvents) for more information on this.