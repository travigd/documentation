---
outputFileName: index.html
---

# Step 1 - Install, run, and write your first event

[!include[<Getting Started Intro>](~/getting-started/_intro.md)]

This first step covers installation and running Event Store, and writing your first event.

## Install Event Store Server

### [Windows](#tab/tabid-1)

The prerequisites for Installing on Windows are:

-   NET Framework 4.0+
-   Windows platform SDK with compilers (v7.1) or Visual C++ installed (Only required for a full build)

Event Store has [Chocolatey packages](https://chocolatey.org/packages/eventstore-oss) available that you can install with the following command:

```powershell
choco install eventstore-oss
```

You can also [download](https://eventstore.org/downloads/) a binary, unzip the archive and run from the folder location with an administrator console:

```powershell
EventStore.ClusterNode.exe --db ./db --log ./logs
```

This command starts Event Store with the database stored at the path _./db_ and the logs in _./logs_. You can view further command line arguments in the [server docs](~/server/index.md).

Event Store runs in an administration context because it starts an HTTP server through `http.sys`. For permanent or production instances you need to provide an ACL such as:

```powershell
netsh http add urlacl url=http://+:2113/ user=DOMAIN\username
```

### [Linux](#tab/tabid-2)

The prerequisites for Installing on Linux are:

-   We recommend [Mono 4.6.2](https://www.mono-project.com/download/stable/), but later versions may also work.

Event Store has pre-built [packages available for Debian-based distributions](https://packagecloud.io/EventStore/EventStore-OSS), [manual instructions for distributions that use RPM](https://packagecloud.io/EventStore/EventStore-OSS/install#bash-rpm), or you can [build from source](https://github.com/EventStore/EventStore#linux).

If you installed from a pre-built package, start Event Store with:

```bash
sudo systemctl start eventstore
```

When you install the Event Store package, the service doesn't start by default. This is to allow you to change the configuration, located at _/etc/eventstore/eventstore.conf_ and to prevent creating a default database.

In all other cases you can run the Event Store binary or use our _run-node.sh_ shell script which exports the environment variable `LD_LIBRARY_PATH` to include the installation path of Event Store, which is necessary if you are planning to use projections.

```bash
./run-node.sh --db ./ESData
```

> [!NOTE]
> We recommend that when using Linux you set the 'open file limit' to a high number. The precise value depends on your use case, but at least between `30,000` and `60,000`.

### [Docker](#tab/tabid-3)

Event Store has [a Docker image](https://hub.docker.com/r/eventstore/eventstore/) available for any platform that supports Docker:

```bash
docker run --name eventstore-node -it -p 2113:2113 -p 1113:1113 eventstore/eventstore
```

* * *

> [!NEXT]
> Read the [server](~/server/index.md) section of our documentation for more details on setting up and running the Event Store server.

## Interacting with an Event Store Server

There are three ways to interact with Event Store:

1.  With the admin web interface (more details link).
2.  [With the HTTP API](~/http-api/index.md).
3.  With a Client API, our documentation covers the [.NET API](~/dotnet-api/index.md), but [others](~/getting-started/which-api-sdk.md) are available.

To use a client API you need to install it first, [install the .NET Core client API](https://www.nuget.org/packages/EventStore.ClientAPI.NetCore/) using your preferred method, add it to your project and require it in your code.

```shell
dotnet add package EventStore.Client
```

```csharp
using EventStore.ClientAPI;
```

## Connecting to Event Store

If you want to use the admin web interface or the HTTP API, then you use port `2113`, for example, <http://127.0.0.1:2113/> in your web browser, or `curl -i http://127.0.0.1:2113` for the HTTP API.

> [!TIP]
> The default username and password is `admin:changeit`

![The Web Admin Dashboard](~/images/es-web-admin-dashboard.png)

If you want to use the .NET API, then you use port `1113` and create a connection, giving it a name:

[!code-csharp[getting-started-connection](~/code-examples/getting-started/docs-example-csharp/Program.cs?start=32&end=33)]

> [!NEXT]
> In this example we used the [`EventStoreConnection.Create()`](#EventStore.ClientAPI.EventStoreConnection.Create(System.String,System.String)) overloaded method but [others are available](#EventStore.ClientAPI.EventStoreConnection).

## Writing Events to an Event Stream

Event Store operates on a concept of Event Streams, and the first operation we look at is how to write to a stream. If you are Event Sourcing a domain model, a stream equates to an aggregate function. Event Store can handle hundreds of millions of streams, so create as many as you need.

If you post to a stream that doesn’t exist, Event Store creates it before adding the events.

To begin, open a text editor, copy and paste the following event definition, and save it as _event.json_.

[!code-json[getting-started-write-event-json](~/code-examples/getting-started/event.json "The contents of event.json")]

You can write events using the admin web interface by clicking the _Stream Browser_ tab, the _Add Event_ button, filling in the form with relevant values and clicking the _Add_ button at the bottom of the page.

![Creating an event with the web admin interface](~/images/getting-started-add-event.gif)

### [HTTP API](#tab/tabid-4)

To use the HTTP API, use the following cURL command, passing the name of the stream and the events to write:

[!code-bash[getting-started-write-event-request](~/code-examples/getting-started/write-event.sh?start=1&end=1)]

> [!NEXT]
> [Read this guide](~/http-api/creating-a-stream.md) for more information on how to write events with the HTTP API.
>
> [!NOTE]
> You can also post events to the HTTP API as XML, by changing the `Content-Type` header to `XML`.

### [.NET API](#tab/tabid-5)

To use the .NET API, use the following method, passing the name of the stream, the version, and the events to write:

[!code-csharp[getting-started-write-event-request](~/code-examples/getting-started/docs-example-csharp/Program.cs?range=95)]

> [!NEXT][read this guide](~/http-api/writing-to-a-stream.md) for more information on how to write events with the .NET API. We don't cover version checking in this guide, but you can read more in [the optimistic concurrency guide](~/dotnet-api/optimistic-concurrency-and-idempotence.md).

* * *

## Next Step

In this first part of our getting started guide you learned how to install and run Event Store and write your first event. The next part covers reading events from a stream.

- [Step 2 - Read events from a stream and subscribe to changes](~/getting-started/reading-subscribing-events.md)
