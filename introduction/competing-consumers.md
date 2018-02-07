---
section: "Introduction"
version: "4.0.2"
---
# Competing Consumers Introduction
Beginning with version **3.2.0** a new subscription model is available in Event Store. This model is known as "competing consumers" and is similar to subscriptions models you may have used in the past such as AMQP. This document serves as a high level overview of the functionality, what it can provide, and when you may want to use it.

## What is Competing Consumers

Competing Consumers differs in usage and functionality from the `Subscribe` operation or from a `CatchUpSubscription`. <!-- TODO: We han't mentioned this yet, is this subscribe? --> For example `SubscribeToStream` will read the events from this point forward that happen in a stream. A `CatchUpSubscription` will read all the events in a stream to your client from a given point.

Both a `Subscription` and a `CatchupSubscription` use a model where the client holds the state of the subscription, much like a blog client remembers the last post you read. The server does not hold any state particular to a given client. With Competing Consumers the server remembers the state of the subscription, allowing for different modes of operations compared to a subscription where the client holds the subscription state. <!-- TODO: Is this repetetive? -->

## Subscription Groups

The first step in using Competing Consumers is to create a new subscription. You can do this with the HTTP API or with the client API `CreatePersistentSubscription`. This creates the server-side subscription group that you use in the future. There are lots of options you can pass to a subscription group including `ReadBatchSizes`, `MaxRetryCounts`, and how often to `CheckPoint` the subscription <!-- TODO: Should the others also have brief explanations -->.

You create a subscription as part of a deployment or an administrative task. You can create subscription groups to map to any stream.

For example to create a consumer group `foo` on the stream `bar`.

<!-- TODO: What specificslly is this an example of? -->

```http
/subscriptions/bar/foo
```

You can also create multiple subscription groups on a single stream.

```http
/subscriptions/bar/foo
/subscriptions/bar/baz
```

One major difference with client-based subscriptions is that a subscription group can have 'N' clients connected to it. The subscription group as a whole represents the subscription. If you connect three clients to a subscription group, only one of the clients will normally receive the message, not all three as it would work with three `CatchUpSusbcription`s.

<!-- TODO: Is this necessary? -->

> [!NOTE]
> It will be discussed later in this document but in the case of retries, connection failures, or server failures, more than one subscriber in a subscriber group can see a given message. Therefore this model is known as At-Least-Once messaging. Clients must be able to handle receiving a message more than one time.

The next step is to connect a client to the subscription group. In the .NET client api there is a `ConnectToPersistentSubscription` method  which takes the stream or group that you want to connect to. It also takes a parameter which is the maximum number of in flight messages. This parameter is key to understanding how the subscription group works.

When a message is dispatched to a client of the subscription group it is considered "in process" until it is acknowledged by the client, not acknowledged by the client, or timed out. The in flight messages limit refers to how many messages can be "in process" at a given point in time by a client, each client sets their limit at their time of connection. Once you have reached this limit the server will not push another message to your client until a slot becomes available due to an "in process" message marked no longer in process.

If you had 7 messages in a subscription and two clients (A/B) (A is allowed 2, and B is allowed 3) the subscription would push messages 1 and 2 to client A and 3,4 and 5 to client B. Message 6 would not be able to be processed until one of the messages 1,2,3,4 and 5 were moved from the "in process" by an ack, nak, or timeout from clients A or B.

The most common mechanism for a slot becoming open would be that client A(or B) returns an acknowledgement that they have processed, say message 1. They can also return a not acknowledgement of a message with hints to the server as to what to do with the message (skip/retry/park/server decides). A timeout of the message (which is configurable) is another way this can happen.

> [!NOTE]
> Tuning of the maximum number of inflight messages and message timeouts are important when looking at overall subscription performance.

## Parked Messages

One option that can return a "not acknowledged" is that the message is not be able to be processed on retries and should be parked (this is also known as a dead letter queue). Messages can also be parked due to them being retried more than a certain number of times.

For every subscription group there is another stream known as the "parked message queue". You can replay the parked message queue at any point to the subscription group either via the UI or via the restful interface for competing consumers. For more information please see version specific information<!-- how can this be more useful -->. It is important in a production environment to monitor the count of parked messages as these represent messages that were **not** delivered to the subscriber group as there were failures.

## Checkpoints

As the subscription is processed, it will occasionally write in a persistent way the place it knows that it has processed all messages prior. This is helpful in the case of a server restart or a crash so the subscription group can continue from this point as opposed to starting from the beginning of the subscription. If running in a clustered version the subscription groups will move to another server. In the case of a crash they will be restarted from their last checkpoint. A reload to a checkpoint can cause a subscription to duplicate messages that are ahead of the latest checkpoint but have been acknowledged.

The configuration settings on the subscription group control how the server checkpoints. You can control how often checkpoints are written via three main config points `CheckpointInterval`, `MinToCheckpoint`, and `MaxToCheckpoint`. An interval, of say 3 seconds will write a checkpoint on the interval providing the number of messages to checkpoint is greater than `MinToCheckpoint`. When `MaxToCheckpoint` is reached a checkpoint will always be written.

If you have an interval of one second, `MinToCheckpoint` at 5 and `MaxToCheckpoint` at 10 (these numbers are normally larger for busy subscriptions)

```text
interval hit: messages = 3 //no checkpoint written
on ack: messages = 4 //no checkpoint written
interval hit: messages = 4 //no checkpoint written
on ack: messages = 5 //no checkpoint written
on interval hit: messages = 5 //checkpoint written
or
on ack messages=10 //checkpoint written
```

Understanding how checkpointing works and paying careful attention to the behavior of your stream can help reduce server workload and help prevent receiving too many repeated messages in the case of a server failover. On a stream receiving few messages the above settings are fine. On a stream receiving a few hundred or thousand messages per second these values need to be significantly higher. A general rule of thumb is the maximum should be 1-5 seconds of message throughput.

> [!NOTE]
> The checkpoints themselves are stored in streams and are often recycled quickly. For this reason it is generally recommended that you occasionally run a scavenge process on your servers if using competing consumers.

## When to Use Competing Consumers

As mentioned throughout this guide, there are many pros and cons when comparing client-based vs server-based subscription models. The table below summarizes some of these trade offs.

<table>
    <thead>
        <tr>
            <th>Feature</th>
            <th>Client Based</th>
            <th>Server Based</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Many clients connected</td>
            <td>Yes</td>
            <td>Yes</td>
        </tr>
        <tr>
            <td>Clients receive all messages</td>
            <td>Yes</td>
            <td>No</td>
        </tr>
        <tr>
            <td>Monitorable</td>
            <td>No*</td>
            <td>Yes</td>
        </tr>        
        <tr>
            <td>Assured Ordering</td>
            <td>Yes</td>
            <td>No</td>
        </tr>
        <tr>
            <td>Requires Configuration</td>
            <td>No</td>
            <td>Yes</td>
        </tr>        
        <tr>
            <td>Load balancing</td>
            <td>No*</td>
            <td>Yes</td>
        </tr>
        <tr>
            <td>HA clients</td>
            <td>No*</td>
            <td>Yes</td>
        </tr>
    </tbody>
</table>

Competing consumers will allow you to connect one or many clients to a given subscription group. This can allow for things like load balancing the work across them or making the clients themselves highly available easily. If you lose a client the workload will just be spread over the other connected clients. With a `CatchupSubscription` it is difficult to make a highly available subscriber (it duplicates everything) load balancing is also difficult, as with a `CatchUpSubscription` each client will receive every message.

For something like a projection of an event stream into a read model, a client will generally prefer to use a `CatchUpSubscription` as opposed to a competing consumer group. This is because when performing this process, receiving the events in order is important. Any time that ordering becomes a primary concern, a `CatchUpSubscription` is probably the best bet.

Another tradeoff to consider is that since a server-based subscription stores the state of the subscription on the server you can centrally monitor the subscriptions from a single point. If they are client-based subscriptions you can do this as well providing all your client subscriptions store their state in a particular place but it is left to the user to implement.

## Monitoring

You can monitor all subscriber state within Event Store. You can do this through the UI (_subscriptions_ tab) or via the restful API (_<http://yourserver/subscriptions>_). You can monitor all competing consumer subscriptions here, and there are dashboards to see what is going on.

Generally it is most important to monitor the relationship between the `lastProcessedMessage`, the `lastKnownMessage`, and the throughput of the subscription. This tells you the last processed message was 'x', the last known message is 'y' and your current throughput is 't'. `X - Y / t` gives you a rough estimate of how far behind the subscription group is from live.

You can also measure your clients, timing each message passed to a client. Using the `extrastatistics` configuration option, the subscription will track a histogram of the timings of the client(s). From this histogram you can get statistics such as average, standard deviation, quintiles, and %s (90,95,99,99.9,etc) about how your client is behaving in terms of timings.
