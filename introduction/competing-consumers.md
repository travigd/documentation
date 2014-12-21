---
title: "Competing Consumers Introduction"
section: "Introduction"
---

Beginning with version 3.0.2 a new subscription model is available in Event Store. This model is known as competing consumers and is very similar to subscriptions models you may have dealt with in the past such as AMQP. This document serves as a high level overview of the functionality, what it can provide, and when you may want to use it.

<span class="note">Competing Consumers only exists in version 3.0.2 and above. Please see specific version documentation in order to gain more details on methods names etc.</span>

## What is Competing Consumers

Competing Consumers is another subscription model that is available, it differs in usage from the Subscribe operation or from a CatchUpSubscription in terms of how it works. SubscribeToStream as example will read the events from this point forward that happen in a stream. A CatchUpSubscription will read all the events in a stream to your client from a given point.

Both a Subscription and a CatchupSubscription use a model where the client holds the state of the subscription much like with a blog client your client remembers the last post that you have read. The server does not hold any state particular to a given client.  Competing Consumers operate differently, with Competing Consumers the server remembers the state of the subscription. This allows for many different modes of operations compared to a subscription where the client holds the subscription state.

The first step in using Competing Consumers is to create a new subscription. This can be done either over the http api or through the client api (CreatePersistentSubscription) at this point. This will create the server side subscription group that you will be able to use in the future. There are lots of options that can be passed to a subscription group including things such as ReadBatchSizes, MaxRetryCounts, and how often to CheckPoint the subscription. The creation of the subscription is normally done as part of a deployment or an administrative task.

Subscription groups can be created to map to any stream. As an example you could create a consumer group foo on the stream bar.

/subscriptions/bar/foo

You can also create multiple subscription groups on a single stream.

/subscriptions/bar/foo
/subscriptions/bar/baz

A subscription group can then have N clients connect to it. The subscription group as a whole represents the subscription. If you connect three clients to a subscription group only one of the clients will normally receive the message not all three as it would work with three CatchUpSusbcriptions.

The next step is connecting a client to the subscription group. In the .NET client api there is a method ConnectToPersistentSubscription which takes the stream/group that you want to connect to. It also takes a parameter which is the maximum number of in flight messages. This parameter is key to understanding how the subscription group works.

When a message is dispatched to a client of the subscription group it is considered "In Process" until it is Acknowledged by the client, Not Acknowledged by the client, or timed out. The in flight messages limit refers to how many messages can be "In Process" at a given point in time. Once you have reached this limit the server will not push another message to your client until a slot becomes available due to an "In Process" message being marked no longer in process. 

