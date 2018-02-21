---
uid: eventstore.org/Event Store HTTP API/4.0.2/createStream
---
# Creating a Stream

<!--  TODO: So document the API endpoint? -->

> [!NOTE]
> As of Event Store 2.0.0, there is no explicit stream creation operation, as there is no longer a `$StreamCreated` as the first event in every stream.

To set stream metadata (for example, an access control list or a maximum age or count of events), use the operations described in [Stream Metadata](stream-metadata.md), and then post to the stream using the operations described in [Writing to a Stream)](writing-to-a-stream.md).
