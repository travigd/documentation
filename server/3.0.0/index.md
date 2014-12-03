---
title: "Running the Event Store"
section: "Server"
version: 3.0.0
pinned: true
---

The Event Store runs as a server, to which many clients can connect either over HTTP or using one of the client APIs which operate using TCP. The open source version can run a single server node, whereas the commercial version can operate a highly available cluster of servers.

## Running the Open Source version

### TL;DR version

A typical command line for starting the Event Store is:

On Windows and .NET (from an account with permission to listen for HTTP traffic):

```
c:\EventStore> EventStore.SingleNode.exe --db .\ESData
```

On Linux and Mono:

```
$ mono-sgen EventStore.SingleNode.exe --db ./ESData
```

### Longer version

The open source version of Event Store is distributed as a console application. There are separate distributions for Windows on .NET and Linux on Mono.

The executable for the open source version of Event Store is `EventStore.SingleNode.exe`.

**Unless passed a database path, the Event Store will write to new database created in the system temporary files path each time it is started.** for more on [Command Line Arguments]({{ site.url }}/introduction/command-line-arguments).

## Platform Specifics

### On Windows and .NET

The Event Store has an HTTP interface - consequently the identity under which you want to run the Event Store must be configured have permission to listen to incoming HTTP requests, as detailed [here](http://msdn.microsoft.com/en-us/library/ms733768.aspx).

In order to configure an account with permission to listen for incoming HTTP
requests, you can execute the following in PowerShell or CMD running as
administrator (replace `DOMAIN\username` with the actual account, and the port number if not running on the default of 2113)

```
netsh http add urlacl url=http://+:2113/ user=DOMAIN\username
```

Also but the port may need to be opened on the machine or corporate firewall to allow access to the service.

#### If you get 503 errors from the web UI

There is a [known issue](http://stackoverflow.com/questions/8142396/what-causes-a-httplistener-http-503-error) with the .NET `HTTPListener` class (which the Event Store uses) and bad URL ACL registrations which can cause servers to return 503 errors for every request. If you see this, you can issue the following commands:

```
netsh http show urlacl
```

Look for an entry on the port you're trying to use (`2113` unless you've specified a custom port) - it will probably look something like: `http://+:2113`. Then issue:

```
netsh http delete urlacl <the entry you just found>

(e.g.):
netsh http delete urlacl http://+:2113
```

This should resolve the issue.

### On Linux and Mono

Event Store runs on Mono version 3.2.3 or greater (as this was the first release after our patches were accepted).

In order to use projections, you must export the environment variable `LD_LIBRARY_PATH` to include the installation path of the Event Store, where `libv8.so` and `libjs1.so` can be found.