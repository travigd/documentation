---
title: "Creating a Stream"
section: "HTTP API"
version: "4.0.2"
---

> [!NOTE]
>
As of Event Store 2.0.0, there is no explicit stream creation operation, as there is no longer a `$StreamCreated` as the first event in every stream.


To set stream metadata (for example, an access control list or a maximum age or count of events), use the operations described in [Stream Metadata]({{site.baseurl}}/http-api/stream-metadata), and then post to the stream using the operations described in [Writing to a Stream)]({{site.baseurl}}/http-api/writing-to-a-stream).
