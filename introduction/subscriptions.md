---
title: "Types of Subscriptions"
section: "Introduction"
version: "4.0.2"
---

When using the Event Store client APIs, clients can subscribe to a stream and be notified when new events are written to that stream. There are three types of subscription are available, all of which can be useful in different situations.

## Volatile Subscriptions

This subscription calls a given function for events written after the subscription is established. They are useful when it is important to be notified with minimal latency when new events are written, but where it is not necessary to process every event.

For example, if a stream has 100 events in it when a subscriber connects, the subscriber can expect to see event number 101 onwards until the time the subscription is closed or dropped.

## Catch-Up Subscriptions

This subscription specifies a starting point, in the form of an event number or transaction file position. The given function will be called for events from the starting point until the end of the stream, and then for subsequently written events. They are useful when building an event-sourced system adhering to the CQRS pattern, the denormalizers creating query models can use catch-up subscriptions to have events pushed to them as they are written to Event Store.

For example, if a starting point of 50 is specified when a stream has 100 events in it, the subscriber can expect to see events 51 through 100, and then any events subsequently written until the subscription is dropped or closed.

## Persistent Subscriptions

<span class="note">Persistent subscriptions exist in version 3.2.0 and above of Event Store.</span>

This subscriptions supports the "competing consumers" messaging pattern. The subscription state is stored server side in Event Store and allows for at-least-once delivery guarantees across multiple consumers on the same stream. They are useful when it is desirable to distribute messages to many workers.

It is possible to have many groups of consumers compete on the same stream, with each group getting an at-least-once guarantee.
