# HTTP API: Optional HTTP Headers

Event Store supports the use of custom HTTP headers for requests.

> [!NOTE]
>  The headers were previously in the form `X-ES-ExpectedVersion` but have changed to `ES-ExpectedVersion` in compliance with RFC-6648 <http://tools.ietf.org/html/rfc6648>.

The headers supported are:

-   [ES-ExpectedVersion](expected-version.md) The expected version of the stream (allows optimistic concurrency)
-   [ES-ResolveLinkTo](resolve-linkto.md) Whether to resolve `linkTo`s in stream
-   [ES-RequiresMaster](requires-master.md) Whether this operation needs to be run on the master node
-   [ES-TrustedAuth](trusted-intermediary.md) Allows a trusted intermediary to handle authentication
-   [ES-LongPoll](longpoll.md) Instructs the server to do a long poll operation on a stream read
-   [ES-HardDelete](harddelete.md) Instructs the server to hard delete the stream when deleting as opposed to the default soft delete
-   [ES-EventType](eventtype.md) Instructs the server the event type associated to a posted body
-   [ES-EventId](eventid.md) Instructs the server the event id associated to a posted body
    ![Google analytics pixel](https://gaproxy-1.apphb.com/UA-40176181-1/Wiki/Optional-Http-Headers)
