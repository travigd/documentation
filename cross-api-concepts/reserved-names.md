---
layout: docs
title: "Reserved Names"
---

The Event Store uses event streams and metadata to support features internally. For example there are metadata flags on streams and events.

All internal data used by the event store itself will be prefixed with a `$` character (for example `$maxCount` on a stream’s metadata).

*You should not use names with a `$` prefix for event names, metadata keys, or stream names for purposes other than what is documented. The Event Store will not stop you doing this, but you may run into issues in future.*

## Stream Metadata

The following names *can* be used as metadata keys when creating a stream, and have specific meaning to the Event Store:

- `$maxAge` — the maximum age in seconds that you wish to allow events to live in this stream. If there are events older than this, scavenging will feel free to delete them. 

- `$maxCount` — this represents the maximum count of events you want in this stream. If scavenging runs and there are more than this, it will feel free to delete them. 

The Event Store uses the most stringent of criteria between `$maxAge` and `$maxCount` - in other words it is an OR. If you set `$maxAge` to 10 and `$maxCount` to 50,000 it will allow up to 50,000 events in a 10 second period anything after that will appear to be deleted. However items are not actually deleted until the next scavenge process is run.

- `$cacheControl` — this represents the time in second that the head node of the stream should be marked as cacheable for. If  for instance you had slowly changing data and lots of subscribers over atom you might want to set this to 5 seconds as the head is generally not cacheable. This will allow intermediaries to handle some of the workload instead of it coming back to the Event Store.

## Event Types

The following names **must not** be used as event types:

## Event Metadata

The following names *can* be used as metadata keys for for events.

- `$correlationId` — the application level correlation ID associated with this message.

- `$causationId` — the application level causation ID associated with this message.

Projections will honor both the correlationId and causationId patterns for any events it produces internally (linkTo/emit/etc).