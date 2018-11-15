---
outputFileName: index.html
---

# Scavenging events

When you delete events or streams in Event Store, they aren't removed immediately. To permanently delete these events you need to run a 'scavenge' on your database.

A scavenge reclaims disk space by rewriting your database chunks, minus the events to delete, and then deleting the old chunks. Once a scavenge has run, you cannot recover any deleted events.

> [!NOTE]
> Scavenges only affect completed chunks, so deleted events in the current chunk are still there after you run a scavenge.

## Starting a scavenge

Scavenges are not run automatically by Event Store. We recommendation that you set up a scheduled task, for example using cron or Windows Scheduler, to trigger a scavenge as often as you need.

You can start a scavenge by issuing an empty `POST` to the HTTP API with the credentials of an `admin` or `ops` user:

### [Request](#tab/tabid-8)

[!code-bash[server-scavenge-request](~/code-examples/server/scavenge.sh?start=1&end=1)]

> [!TIP]
> You can specify the chunk to start a scavenge from by using the `?startFromChunk=<CHUNK_ID>"` parameter.

### [Response](#tab/tabid-9)

[!code-http[server-scavenge-response](~/code-examples/server/scavenge.sh?range=3-)]

* * *

You can also start scavenges from the _Admin_ page in the Admin UI.

<!-- TODO: Scavenge with .NET API? -->

> [!TIP]
> Each node in a cluster has its own independent database. As such, when you run a scavenge, you need to issue a scavenge request to each node.

## How often should you run a scavenge

This depends on the following:

-   How often you delete streams.
-   Depending on how you set `$maxAge`, `$maxCount` or `$tb` metadata on your streams.

<!-- TODO: Advice here would be good -->

## Scavenging while Event Store is online

It's safe to run a scavenge while Event Store is running and processing events, as it's designed to be an online operation.

Scavenging increases the number of reads and writes made to your disk, and it's not recommended to run it when your system is under heavy load.
