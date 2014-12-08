---
title: "Connecting to a Server"
section: ".NET API"
version: 3.0.0
---

## EventStoreConnection

The `EventStoreConnection` class is responsible for maintaining a full-duplex connection between the client and the Event Store server. `EventStoreConnection` is thread-safe, and it is recommended that only one instance per application is created.

All operations are handled fully asynchronously, returning either a `Task` or a `Task<T>`. If you need to execute synchronously, simply call `.Wait()` on the asynchronous version.

To get maximum performance from the connection, it is recommended that it be used asynchronously.

## Creating a Connection

The static `Create` methods on `EventStoreConnection` are used to create a new connection. All overloads allow you to optionally specify a name for the connection, which is returned when the connection raises events (see [Connection Events]()).

<table>
    <thead>
        <tr>
            <th>Method</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><code>Create(IPEndPoint tcpEndPoint)</code></td>
            <td>Connects to a single node with default settings</td>
        </tr>
        <tr>
            <td><code>Create(ConnectionSettings settings, IPEndPoint tcpEndPoint)</code></td>
            <td>Connects to a single node with custom settings</td>
        </tr>
        <tr>
            <td><code>Create(ConnectionSettings settings, IPEndPoint tcpEndPoint)</code></td>
            <td>Connects to a multi node cluster with custom settings</td>
        </tr>
    </tbody>
</table>

## Connection Settings

There are a number of different options which can be specified when making a connection to the Event Store using the client API. These options are encapsulated into an object of type `ConnectionSettings` which is passed as a paramater to the `Create` methods listed above.

Instances of ConnectionSettings are created using a fluent builder class as follows:

```CSharp
ConnectionSettings settings = ConnectionSettings.Create();
```

This will create a `ConnectionSettings` with the default options. These can be overridden with the builder methods described below.

### Logging Destinations

The Client API can log information about what it is doing to a number of different destinations. By default, no logging is enabled.

<table>
    <thead>
        <tr>
            <th>Builder Method</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><code>UseConsoleLogger()</code></td>
            <td>Output log messages using <code>Console.WriteLine</code></td>
        </tr>
        <tr>
            <td><code>UseDebugLogger()</code></td>
            <td>Output log messages using <code>Debug.WriteLine</code></td>
        </tr>
        <tr>
            <td><code>UseCustomLogger()</code></td>
            <td>Output log messages to the specified instance of `ILogger` (You should implement this interface in order to log using another library such as NLog or log4net)</td>
        </tr>
    </tbody>
</table>

### Log Verbosity

By default, information about connection, disconnection and errors are logged. However it can be useful to have more information about specific operations as they are occuring. To enable verbose logging use the following method on `ConnectionSettingsBuilder`:

<table>
    <thead>
        <tr>
            <th>Builder Method</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><code>EnableVerboseLogging()</code></td>
            <td>Turns on verbose logging</td>
        </tr>
    </tbody>
</table>

## Connection Security

The Client API and Event Store can communicate either over SSL or an unencrypted channel. **When credentials are being passed outside of development, it is important to use an SSL-encrypted connection and to validate the server certificate.**

### Using an unencrypted connection

The following method on `ConnectionSettingsBuilder` sets the connection to be unencrypted:

- `UseNormalConnection()` - uses an unencrypted connection *(default)*

### Using an SSL-encrypted connection

To configure the client-side of the SSL connection, use the following method on `ConnectionSettingsBuilder`:

- `UseSslConnection(string targetHost, bool validateServer)` - uses an SSL-encrypted connection where:
	- `targetHost` is the name specified on the SSL certificate installed on the server.
	- `validateServer` controls whether or not the server certificate is validated upon connection.

*Note: in production systems, `validateServer` should be set to `true`, and SSL-encrypted connections should be used if credentials are being sent from the client to the Event Store. For more information on setting up the server end of the Event Store for SSL, see [SSL Setup](wiki/Setting-Up-SSL-In-Windows)*

## Operation Node Preference

When connecting to an Event Store HA cluster, you can specify that operations can be performed on any node, or only on the node which is the master.

- `builder.PerformOnAnyNode()`
- `builder.PerformOnMasterOnly()`

*More to come…*