---
section: ".NET API"
version: "4.0.2"
---
# Optimistic Concurrency & Idempotence

Writing supports an optimistic concurrency check on the version of the stream to which events are written. The method of specifying what the expected version is depends whether you are making writes using the HTTP or .NET API.

The .NET API has constants which you can use to represent certain conditions:

<table>
    <thead>
        <tr>
            <th>Parameter</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><code>ExpectedVersion.Any</code></td>
            <td>This disables the optimistic concurrency check.</td>
        </tr>
        <tr>
            <td><code>ExpectedVersion.NoStream</code></td>
            <td>This specifies the expectation that target stream does not yet exist.</td>
        </tr>
        <tr>
            <td><code>ExpectedVersion.EmptyStream</code></td>
            <td>This specifies the expectation that the target stream has been explicitly created, but does not yet have any user events written in it.</td>
        </tr>
        <tr>
            <td><code>ExpectedVersion.StreamExists</code></td>
            <td>This specifies the expectation that the target stream or its metadata stream has been created, but does not expect the stream to be at a specific event number.</td>
        </tr>
        <tr>
            <td><code>Any other integer value</code></td>
            <td>The event number that you expect the stream to currently be at.</td>
        </tr>
    </tbody>
</table>

If the optimistic concurrency check fails during writing, a `WrongExpectedVersionException` is thrown.

## Idempotence

If identical write operations occur, they are treated in a way which makes it idempotent. If a write is treated in this manner, it is acknowledged as successful, but duplicate events will not written. The idempotence check is based on the `EventId` and `stream`. It is possible to reuse an `EventId` across streams whilst maintaining idempotence.

The level of idempotence guarantee depends on whether the optimistic concurrency check is not disabled during writing (by passing `ExpectedVersion.Any` as the `expectedVersion` for the write).

### If an expected version is specified

The specified `expectedVersion` is compared to the `currentVersion` of the stream. This will yield one of three results:

- **`expectedVersion > currentVersion`** - a `WrongExpectedVersionException` will be thrown.

- **`expectedVersion == currentVersion`** - events will be written and acknowledged.

- **`expectedVersion < currentVersion`** - the `EventId` of each event in the stream starting from `expectedVersion` are compared to those in the write operation. This can yield one of three further results:

	- **All events have been committed already** - the write will be acknowledged as successful, but no duplicate events will be written.

	- **None of the events were previously committed** - a `WrongExpectedVersionException` will be thrown.

	- **Some of the events were previously committed** - this is considered a bad request. If the write contains the same events as a previous request, either all or none of the events should have been previously committed. This currently surfaces as a `WrongExpectedVersionException`.

### If `ExpectedVersion.Any` is specified

*Idempotence is __not__ guaranteed if `ExpectedVersion.Any` is used. The chance of a duplicate event being written is small, but it does exist.*

The idempotence check will yield one of three results:

- **All events have been committed already** - the write will be acknowledged as successful, but no duplicate events will be written.

- **None of the events were previously committed** - the events will be written and the write will be acknowledged.

- **Some of the events were previously committed** - this is considered a bad request. If the write contains the same events as a previous request, either all or none of the events should have been previously committed. This currently surfaces as a `WrongExpectedVersionException`.
