---
title: "Connection Options"
section: ".NET API"
version: 3.0.1
---

There are a number of different options which can be specified when making a connection to the Event Store using the client API. These options are encapsulated into an object of type `ConnectionSettings`, for which there is a fluent builder which aims to be reasonably descriptive. The `ConnectionSettings` object is passed as a parameter when creating whichever `IEventStoreConnection` implementation is needed.

This section describes the options available and what effect each has.

## Creating a `ConnectionSettingsBuilder`

A `ConnectionSettingsBuilder` is a fluent builder with an implicit conversion back to `ConnectionSettings` which can be created in one of two ways:

```
ConnectionSettings settings = ConnectionSettings.Create();
```

or

```
ConnectionSettings settings = new ConnectionSettingsBuilder();
```

Both of these methods will create a `ConnectionSettings` with the default options - passing in settings at all is only necessary if you want to override any of the defaults.

## Logging

The Client API can log information about what it is doing at a two different verbosity levels, and to a number of different destinations.

### Disabling all logging

To disable all logging, use the following method on the `ConnectionSettingsBuilder`:

- `builder.DoNotLog()` - disables logging *(default)*

This is the default if no logging options are specified.

### Enabling logging

The following three methods can be used to enable logging:

- `builder.UseConsoleLogger()` - Output log messages using `Console.WriteLine`.

- `builder.UseDebugLogger()` - Output log messages using `System.Diagnostics.Debug.WriteLine`.

- `builder.UseCustomLogger(ILogger logger)` - Output log messages to the specified instance of `EventStore.ClientAPI.ILogger` (implement this interface in order to log using another library such as NLog or log4net).

### Verbosity

By default, information about connection, disconnection and errors are logged. However it can be useful to have more information about specific operations as they are occuring. The following methods on `ConnectionSettingsBuilder` control verbosity:

- `EnableVerboseLogging()` - Turns on verbose logging.

- `DisableVerboseLogging()` - Turns off verbose logging *(default)*.

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