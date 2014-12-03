---
title: "Creating a Stream"
section: "HTTP API"
version: 3.0.0
---

*NOTE: As of Event Store 2.0.0, there is no explicit stream creation operation, as there is no longer a `$StreamCreated` as the first event in every stream.*

To set stream metadata (for example, an access control list or a maximum age or count of events), use the operations described [here (Stream Metadata)](https://github.com/EventStore/EventStore/wiki/Stream-Metadata-%28HTTP%29), and then post to the stream using the operations described [here (Writing to a Stream)](https://github.com/EventStore/EventStore/wiki/Writing-to-a-Stream-%28HTTP%29).