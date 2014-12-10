---
title: "Reading Events"
section: ".NET API"
version: 3.0.0
---

The client API can be used to read events from a stream starting from either end of the stream. There is a method for each direction. As well as one for reading a single event.

## Methods

### Reading a single event

```csharp
Task<EventReadResult> ReadEventAsync(string stream, int eventNumber, bool resolveLinkTos);
```

### Reading a stream forwards

```csharp
Task<StreamEventsSlice> ReadStreamEventsForwardAsync(string stream, int start, int count, bool resolveLinkTos)
```

### Reading a stream backwards

```csharp
Task<StreamEventsSlice> ReadStreamEventsBackwardAsync(string stream, int start, int count, bool resolveLinkTos)
```
<span class="note">
These methods also have an additional optional prarmater which allows you to specify the `UserCredentials` to use for the request. If none are supplied, the default credentials for the <code>EventStoreConnection</code> will be used (See <a href="./connecting-to-a-server/#user-credentials">Connecting to a Server - User Credentials</a>).
</span>

## StreamEventsSlice

The reading methods for individual streams each return a `StreamEventsSlice`, which are immutable. The available members on StreamEventsSlice are:

<table>
    <thead>
        <tr>
            <th>Member</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><code>string Stream</code></td>
            <td>The name of the stream for the slice</td>
        </tr>
        <tr>
            <td><code>ReadDirection&nbsp;ReadDirection</code></td>
            <td>Either <code>ReadDirection.Forward</code> or <code>ReadDirection.Backward</code> depending on which method was used to read</td>
        </tr>
        <tr>
            <td><code>int FromEventNumber</code></td>
            <td>The sequence number of the first event in the stream</td>
        </tr>
        <tr>
            <td><code>int LastEventNumber</code></td>
            <td>The sequence number of the last event in the stream</td>
        </tr>
        <tr>
            <td><code>int NextEventNumber</code></td>
            <td>The sequence number from which the next read should be performed to continue reading the stream</td>
        </tr>
        <tr>
            <td><code>bool IsEndOfStream</code></td>
            <td>Whether or not this slice contained the end of the stream at the time it was created</td>
        </tr>
        <tr>
            <td><code>ResolvedEvent[] Events</code></td>
            <td>An array of the events read. See the description of how to interpret a <a href="#ResolvedEvent">Resolved Events</a> below for more information on this</td>
        </tr>
    </tbody>
</table>

## Reading a stream forwards

The `ReadStreamEventsForwardAsync` method reads the requested number of events in the order in which they were originally written to the stream from a nominated starting point in the stream. 

The parameters are:

<table>
    <thead>
        <tr>
            <th>Parameter</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><code>string Stream</code></td>
            <td>The name of the stream to read</td>
        </tr>
        <tr>
            <td><code>int start</code></td>
            <td>The earliest event to read (inclusive). For the special case of the start of the stream, the constant <code>StreamPosition.Start</code> should be used</td>
        </tr>
        <tr>
            <td><code>int count</code></td>
            <td>The maximum number of events to read in this request (assuming that many exist between the start specified and the end of the stream)</td>
        </tr>
        <tr>
            <td><code>bool&nbsp;resolveLinkTos</code></td>
            <td>Determines whether or not any link events encountered in the stream will be resolved. See the discussion on <a href="#ResolvedEvent">Resolved Events</a> for more information on this</td>
        </tr>
    </tbody>
</table>

### Example: Reading an entire stream forwards from start to end

This example uses the `ReadStreamEventsForwardAsync` method in a loop to page through all events in a stream, reading 200 events at a time in order to build a list of all the events in the stream.

```csharp
var streamEvents = new List<ResolvedEvent>();

StreamEventsSlice currentSlice;
var nextSliceStart = StreamPosition.Start;
do
{
	currentSlice = 
    _eventStoreConnection.ReadStreamEventsForward("myStream", nextSliceStart,
                                                  200, false)
                                                  .Result;

	nextSliceStart = currentSlice.NextEventNumber;

	streamEvents.AddRange(currentSlice.Events);
} while (!currentSlice.IsEndOfStream);
```
<span class="note">It is unlikely that client code would need to actually build a list in this manner. It is far more likely that events would be passed into a left fold in order to derive the state of some object as of a given event.</span>

## Reading a stream backwards

The `ReadStreamEventsBackwardAsync` method reads the requested number of events in the reverse order from that in which they were originally written to the stream from a specified starting point.

The parameters are:

<table>
    <thead>
        <tr>
            <th>Parameter</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><code>string Stream</code></td>
            <td>The name of the stream to read</td>
        </tr>
        <tr>
            <td><code>int start</code></td>
            <td>The latest event to read (inclusive). For the end of the stream use the constant <code>StreamPosition.End</code></td>
        </tr>
        <tr>
            <td><code>int count</code></td>
            <td>The maximum number of events to read in this request (assuming that many exist between the start specified and the start of the stream)</td>
        </tr>
        <tr>
            <td><code>bool&nbsp;resolveLinkTos</code></td>
            <td>Determines whether or not any link events encountered in the stream will be resolved. See the discussion on <a href="#ResolvedEvent">Resolved Events</a> for more information on this</td>
        </tr>
    </tbody>
</table>