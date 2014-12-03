---
title: "Overview"
section: ".NET API"
version: 3.0.0
---

The .NET Client API communicates with the Event Store using over TCP, using length-prefixed serialized protocol buffers. The API allows for reading and writing operations, as well as for subscriptions to individual event streams or all events written.

## EventStoreConnection

The EventStoreConnection class is responsible for maintaining a full-duplex connection between the client and the event store server. EventStoreConnection is thread-safe, and it is recommended that only one instance per application is created.

All operations are handled fully asynchronously, returning either a Task or a Task\<T\>. There are versions of each of these methods which can be used in a synchronous manner, however they simply call .Wait() on the asynchronous version.

To get maximum performance from the connection, it is recommended that it be used asynchronously.

### Creating a connection

A new connection can be created using the following static methods on the EventStoreConnection class:

- `public static EventStoreConnection Create()`
- `public static EventStoreConnection Create(ConnectionSettings settings)`

Before use, the instance must be connected to a server using one of:

- `public void Connect(IPEndPoint tcpEndPoint)`
- `public Task ConnectAsync(IPEndPoint tcpEndPoint)`

In both cases, an IPEndPoint is passed as a parameter in order to specify the IP address and port of the server.

###ConnectionSettings

The settings for the EventStoreConnection are specified via a builder.

<table>
<tr>
<th>Builder Method</th>
<th>Description</th>
<tr>
<td>`.DoNotLog`</td>
<td>Configures the connection not to output log messages. This is the default.</td>
</tr><tr>
<td>`.UseCustomLogger(ILogger logger)`</td>
<td>Configures the connection to output log messages to the given instance of `ILogger`.</td>
</tr><tr>
<td>`.UseConsoleLogger()`</td>
<td>Configures the connection to output log messages to the console.</td>
</tr><tr>
<td>`.UseDebugLogger()`</td>
<td>Configures the connection to output log messages to the listeners configured on `System.Diagnostics.Debug`.</td>
</tr><tr>
<td>`.EnableVerboseLogging()`</td>
<td>Turns on verbose <see cref="EventStoreConnection"/> internal logging. Mostly useful for debugging the EventStoreConnection.</td>
</tr><tr>
<td>`.DisableVerboseLogging()`</td>
<td>Turns off verbose <see cref="EventStoreConnection"/> internal logic logging.</td>
</tr><tr>
<td>`.LimitOperationsQueueTo(int limit)`</td>
<td>Sets the limit for number of queued operations</td>
</tr><tr>
<td>`.LimitConcurrentOperationsTo(int limit)`</td>
<td>Limits the number of concurrent operations that this connection can have</td>
</tr><tr>
<td>`.LimitAttemptsForOperationTo(int limit)`</td>
<td>Limits the number of operation attempts. This limit includes the initial attempt.</td>
</tr><tr>
<td>`.LimitRetriesForOperationTo(int limit)`</td>
<td>Limits the number of operation retries.</td>
</tr><tr>
<td>`.KeepRetrying()`</td>
<td>Allows infinite operation retry attempts</td>
</tr><tr>
<td>`.LimitReconnectionsTo(int limit)`</td>
<td>Limits the number of reconnections this connection can try to make.</td>
</tr><tr>
<td>`.KeepReconnecting()`</td>
<td>Allows infinite reconnection attempts.</td>
</tr><tr>
<td>`.EnableOperationsForwarding()`</td>
<td>Enables the forwarding of operations in the Event Store (only affects cluster version)</td>
</tr><tr>
<td>`.DisableOperationsForwarding()`</td>
<td>Disables the forwarding operations in the Event Store (only affects cluster version)</td>
</tr><tr>
<td>`.SetReconnectionDelayTo(TimeSpan reconnectionDelay)`</td>
<td>Sets the delay between reconnection attempts</td>
</tr><tr>
<td>`.SetOperationTimeoutTo(TimeSpan operationTimeout) </td>
<td>Sets the operation timeout duration</td>
</tr><tr>
<td>`.SetTimeoutCheckPeriodTo(TimeSpan timeoutCheckPeriod)`</td>
<td>Sets how often timeouts should be checked for.</td>
</tr><tr>
<td>`.OnErrorOccurred(Action<EventStoreConnection, Exception> handler)`</td>
<td>Sets callback for internal connection errors.</td>
</tr><tr>
<td>`.OnClosed(Action<EventStoreConnection, string> handler)`</td>
<td>Sets callback for when connection is closed.</td>
</tr><tr>
<td>`.OnConnected(Action<EventStoreConnection> handler)`</td>
<td>Sets callback for when connection is established.</td>
</tr><tr>
<td>`.OnDisconnected(Action<EventStoreConnection> handler)`</td>
<td>Sets callback for when connection is disconnected.</td>
</tr><tr>
<td>`.OnReconnecting(Action<EventStoreConnection> handler)`</td>
<td>Sets callback for when reconnection attempt is made.</td>
</tr></table>