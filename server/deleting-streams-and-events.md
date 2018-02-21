# Deleting streams and events

Meta data in Event Store defines whether an event is deleted or not. Stream metadata such as "Truncate Before", "Max Age" and "Max Count" is used to filter out events considered deleted. When reading a stream, the index will check the stream's metadata to determine whether any of its events have been deleted.

`$all` bypasses the index, meaning that it does not check the metadata to determine whether events exist or not. As such, events that have been deleted will still be readable until a scavenge has removed them. There are a number of requirements for a scavenge to successfully remove events, for more information about this, please see the section on [Scavenging](scavenging.md).

> [!WARNING]
> The last event in a stream is always kept as a record of the last event number in the stream.

### Soft delete and Truncate before

**Truncate before** (`$tb`) considers any event with an event number equal to or lower than its value to be deleted.
For example, if you had the following events in a stream :

```text
0@test-stream
1@test-stream
2@test-stream
3@test-stream
```

If you set the truncate before value to 2, a read of the stream would result in only the last event being read :

```text
3@test-stream
```

**Soft delete** makes use of Truncate before. When a stream is deleted, its Truncate before is set to the streams current last event number. When a soft deleted stream is read, the read will return a `StreamNotFound` or `404` result.
After deleting the stream, you are able to write to it again, continuing from where it left off.

For example, if you soft deleted the above example stream, the truncate before would be set to 3 (the stream's current event number). If you were to write to the stream again, the next event would be written with event number 4. Only events from event number 4 onwards would be visible when reading this stream.

### Max count and Max age

**Max count** (`$maxCount`) limits the number of events that can be read from a stream.
If you try to read a stream that has a max count of 5, you will only be able to read the last 5 events regardless of how many events are actually in the stream.

**Max age** (`$maxAge`) specifies the number of seconds an event can live for.
This age is calculated at the time of the read, so if you read a stream with a Max Age of 3 minutes and one of the events in the stream has existed for 4 minutes at the time of the read, it will not be returned.

## Hard delete

A **hard delete** writes a tombstone event to the stream, permanently deleting it. The stream cannot be recreated or written to again.
Tombstone events are written with the event type `$streamDeleted`.
When a hard deleted stream is read, the read will return a `StreamDeleted` or `410` result.

The events in the deleted stream are liable to be removed in a scavenge, but the tombstone event will remain.

> [!WARNING]
> A hard delete of a stream is permanent. The stream cannot be written to or recreated. As such, you should generally prefer to soft delete streams unless you have a specific need to permanently delete the stream.

## Deleted events and projections

If you are intending on using projections and deleting streams, there are some things to take into consideration:

Due to the nature of $all, projections using `fromAll` will read any deleted events that have not been scavenged away. They will also receive any tombstone events from hard deletes.

Projections that read from a specific stream will also receive that stream's metadata events. These can be filtered out by ignoring events with an event type `$metadata`.
