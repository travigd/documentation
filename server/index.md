---
outputFileName: index.html
---

# Running Event Store

Event Store runs as a server, that clients can connect either over HTTP or using one of the client APIs. You can run both the open source and commercial versions, as either a single node, or a highly available cluster of nodes.

The [open source version of Event Store](https://eventstore.org/downloads) is distributed as a console application. There are separate distributions for Windows on .NET and Linux/macOS on Mono.

## Running the Open Source version

> [!WARNING]
> Unless passed a database option, Event Store will write to a new database created in the system’s temporary files path each time it is started. For more information on Command Line Arguments read [this guide](command-line-arguments.md).

### On Windows and .NET

<!-- TODO: Duplication, turn other into partial and reuse -->

A typical command line for running Event Store server on Windows is:

```posh
EventStore.ClusterNode.Exe --db .\ESData
```

#### Setting up HTTP Permissions

Event Store has an HTTP interface and the identity which you want to run Event Store with must have permission to listen to incoming HTTP requests, as detailed [here](http://msdn.microsoft.com/en-us/library/ms733768.aspx).

To configure an account with permission to listen for incoming HTTP requests, you execute the following in PowerShell, or the Command Prompt, running as administrator (replace `DOMAIN\username` with the actual account details, and the port number if you are not using the default port).

```posh
netsh http add urlacl url=http://+:2113/ user=DOMAIN\username
```

<!-- TODO: Is this still true and can it be handled better? -->

#### If you receive 503 errors from the web UI

There is a [known issue](http://stackoverflow.com/questions/8142396/what-causes-a-httplistener-http-503-error) with the .NET `HTTPListener` class (which Event Store uses) and bad URL ACL registrations which can cause servers to return 503 errors for every request. If you see this, you can issue the following commands:

```posh
netsh http show urlacl
```

Look for an entry on the port you’re trying to use (`2113` unless you’ve specified a custom port). It will probably look something like: `http://+:2113/`. Then issue:

```posh
netsh http delete urlacl <the entry you just found>
```

For example:

```posh
netsh http delete urlacl http://+:2113/
```

This should resolve the issue.

### On Linux/macOS

A typical command line for running Event Store server on Linux/macOS is:

```bash
./run-node.sh --db ./ESData
```

Although you can run Event Store binary directly, a `run-node` we provide a shell script which exports the environment variable `LD_LIBRARY_PATH` to include the installation path of Event Store. This is necessary if you are planning to use projections.

Event Store builds for both Linux and macOS have the Mono runtime bundled in, this means that you do not need Mono installed locally to run Event Store.

### Shutting down an Event Store node

Event Store is designed to be safe by default and it is expected that it will be shut down using `kill -9`. However, it is also possible to initiate a shutdown via the web UI, by clicking on the _Shutdown Server_ button located on the _Admin_ page. This may be useful if you do not have console access to the node, or need to script initiating a shutdown.
