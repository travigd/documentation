---
title: "Writing to a Stream"
section: ".NET API"
version: "4.0.2"
---

You can use the client API to write one or more events to a stream atomically. You do this by appending the events to the stream in one operation, or by starting a transaction on the stream, writing events in one or more operations in that transaction, and then committing the transaction.

You can make an optimistic concurrency check during the write by specifying the version at which the stream is expected to be. Identical write operations are idempotent if the optimistic concurrency check is not disabled. You can find more information on optimistic concurrency and idempotence [here]({{site.baseurl}}/dotnet-api/optimistic-concurrency-and-idempotence).

## Methods

### Appending to a stream in a single write

<!-- TODO: Explanations -->

```csharp
Task<WriteResult> AppendToStreamAsync(string stream, long expectedVersion, IEnumerable<EventData> events)
```

```csharp
Task<WriteResult> AppendToStreamAsync(string stream, long expectedVersion, params EventData[] events)
```

### Using a transaction to append to a stream across multiple writes

#### On `EventStoreConnection`

<!-- TODO: Explanations -->

```csharp
Task<EventStoreTransaction> StartTransactionAsync(string stream, long expectedVersion)
```

```csharp
EventStoreTransaction ContinueTransaction(long transactionId)
```

#### On `EventStoreTransaction`

<!-- TODO: Explanations -->

```csharp
Task WriteAsync(IEnumerable<EventData> events)
```

```csharp
Task WriteAsync(params EventData[] events)
```

```csharp
Task CommitAsync()
```

```csharp
void Rollback()
```

## EventData

The writing methods all use a type named `EventData` to represent an event to be stored. Instances of `EventData` are immutable.

Event Store does not have any built-in serialisation, so the body and metadata for each event are represented in `EventData` as a `byte[]`.

The members on `EventData` are:

<table>
    <thead>
        <tr>
            <th>Member</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><code>Guid EventId</code></td>
            <td>A unique identifier representing this event. This is used internally for idempotency if you write the same event twice you should use the same identifier both times.</td>
        </tr>
        <tr>
            <td><code>string Type</code></td>
            <td>The name of the event type. This can be used later for pattern matching in projections, so should be a “friendly” name rather than a CLR type name, for example.</code></td>
        </tr>
        <tr>
            <td><code>bool IsJson</code></td>
            <td>If the data and metadata fields are serialized as JSON, this should be set to true. Setting this to `true` will cause the projections framework to attempt to deserialize the data and metadata later.</td>
        </tr>
        <tr>
            <td><code>byte[] Data</code></td>
            <td>The serialized data representing the event to be stored.</td>
        </tr>
        <tr>
            <td><code>byte[] Metadata</code></td>
            <td>The serialized data representing metadata about the event to be stored.</td>
        </tr>
    </tbody>
</table>

## Appending to a stream in a single write

The `AppendToStreamAsync` method writes events atomically to the end of a stream, working in an asynchronous manner.

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
            <td><code>string stream</code></td>
            <td>The name of the stream to which to append.</td>
        </tr>
        <tr>
            <td><code>long expectedVersion</code></td>
            <td>The version at which we currently expect the stream to be in order that an optimistic concurrency check can be performed. This should either be a positive integer, or one of the constants `ExpectedVersion.NoStream`, `ExpectedVersion.EmptyStream`, or to disable the check, `ExpectedVersion.Any`. See <a href="../optimistic-concurrency-and-idempotence">here</a> for a broader discussion of this.</td>
        </tr>
        <tr>
            <td><code>IEnumerable&lt;EventData&gt; events</code></td>
            <td>The events to append. There is also an overload of each method which takes the events as a `params` array.</td>
        </tr>
    </tbody>
</table>
