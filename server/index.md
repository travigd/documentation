---
outputFileName: index.html
---

# Running Event Store

Event Store runs as a server that clients can connect to either [over HTTP](~/http-api/index.md) or using [one of the client APIs](~/getting-started/which-api-sdk.md). You can run both the open source and commercial versions as either a single node or a highly available cluster of nodes.

We distribute an [open source version of Event Store](https://eventstore.org/downloads) as a console application. There are separate distributions for Windows on .NET and Linux/macOS on Mono.

[!include[<Getting Started Install and run>](~/partials/_install-run.md)]

## Solving 503 errors from the web admin UI

There is a [known issue](http://stackoverflow.com/questions/8142396/what-causes-a-httplistener-http-503-error) with the .NET `HTTPListener` class (which Event Store uses) and bad URL ACL registrations which can cause servers to return 503 errors for every request. If you see this, you can issue the following commands:

```posh
netsh http show urlacl
```

Look for an entry on the port you're trying to use (`2113` unless you've specified a custom port), then issue:

```posh
netsh http delete urlacl <the entry you just found>
```

For example:

```posh
netsh http delete urlacl http://+:2113/
```

These steps should resolve the issue.

## Shutting down an Event Store node

Event Store is designed to be safe by default, and it is expected that it will be shut down using `kill -9`. It is also possible to initiate a shutdown via the web admin UI, by clicking on the _Shutdown Server_ button located on the _Admin_ page. This may be useful if you do not have console access to the node or need to script initiating a shutdown.