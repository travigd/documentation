---
layout: docs
title: ".NET API: Writing to a Stream"
---

The client API can be used to write one or more events to a stream atomically. This can be done either by appending the events to the stream in one operation, or by starting a transaction on the stream, writing events in one or more operations in that transaction, and then committing the transaction.

An optimistic concurrency check can be made during the write by specifying the version at which the stream is expected to be currently. Identical write operations are idempotent if the optimistic concurrency check is not disabled. More information on optimistic concurrency and idempotence can be found [here](../wiki/Optimistic-Concurrency-&-Idempotence).

##Methods

###Appending to a stream in a single write

- `Task **AppendToStreamAsync**(string stream, int expectedVersion, IEnumerable<EventData> events)`

- `Task **AppendToStreamAsync**(string stream, int expectedVersion, params EventData[] events)`

- `void **AppendToStream**(string stream, int expectedVersion, IEnumerable<EventData> events)`

- `void **AppendToStream**(string stream, int expectedVersion, params EventData[] events)`

###Using a transaction to append to a stream across multiple writes

####On `EventStoreConnection`:

- `Task&lt;EventStoreTransaction&gt; **StartTransactionAsync**(string stream, int expectedVersion)`

- `EventStoreTransaction **StartTransaction**(string stream, int expectedVersion)`

- `EventStoreTransaction **ContinueTransaction**(long transactionId)`

####On `EventStoreTransaction`:

- `Task **WriteAsync**(IEnumerable&lt;EventData&gt; events)`

- `Task **WriteAsync**(params EventData[] events)`

- `void **Write**(IEnumerable&lt;EventData&gt; events)`

- `void **Write**(params EventData[] events)`

- `Task **CommitAsync**()`

- `void **Commit**()`

- `void **Rollback**()`

##EventData

The writing methods all use a type named `EventData` to represent an event to be stored. Instances of `EventData` are immutable.

The Event Store does not have any built-in serialization, so the body and metadata for each event are represented in `EventData` as a `byte[]`. Some examples using popular serialization frameworks are available [here](wiki/Building-EventData-Instances-%28.NET API%29).

The members on `EventData` are:

- `Guid **EventId**` - A unique ID for the event. This is used in idempotency checks (see below).

- `string **Type**` - The name of the event type. This can be used later for [pattern matching in projections](wiki/Pattern-Matching-%28Projections%29), so should be a &ldquo;friendly&rdquo; name rather than a CLR type name, for example.

- `bool **IsJson**` - If the data and metadata fields are serialized as JSON, this should be set to true. Setting this to `true` will cause the projections framework to attempt to deserialize the data and metadata later.

- `byte[] **Data**` - The serialized data representing the event to be stored.

- `byte[] **Metadata**` - The serialized data representing metadata about the event to be stored.

##Appending to a stream in a single write

The `AppendToStreamAsync` and `AppendToStream` write events atomically to the end of a stream, working in an async and blocking manner respectively.

The parameters are:

- `string **stream**` - the name of the stream to which to append.

- `int **expectedVersion**` - the version at which we currently expect the stream to be in order that an optimistic concurrency check can be performed. This should either be a positive integer, or one of the constants `ExpectedVersion.NoStream`, `ExpectedVersion.EmptyStream`, or to disable the check, `ExpectedVersion.Any`. See [here](Optimistic-Concurrency-&-Idempotence) for a broader discussion of this.

- `IEnumerable&lt;EventData&gt; **events**` - the events to append. There is also an overload of each method which takes the events as a `params` array.