---
title: "Competing Consumers Configuration"
section: "Server"
version: "3.1.0 (pre-release)"
---

There are many options for configuration within the persistent subscription of event store and performance is highly related to getting the right configuration. This document will go through the varying areas of competing consumers with a particular focus on getting the best performance out of your competing consumer group while explaining how some of the options interact with each other.


###Buffer Size

At the beginning the single most important configuration point to get right is the bufferSize sent from the client when connecting.

```csharp
        EventStorePersistentSubscription ConnectToPersistentSubscription(
            string groupName, 
            string stream, 
            Action<EventStorePersistentSubscription, ResolvedEvent> eventAppeared,
            Action<EventStorePersistentSubscription, SubscriptionDropReason, Exception> subscriptionDropped = null,
            UserCredentials userCredentials = null,
            int bufferSize = 10,
            bool autoAck = true);
```

This bufferSize represents the number of in flight messages (unacknowledged) messages that this client is allowed. If you were to set this value to one then the server will not send your client the next message until it receives the acknowledgement from the previous message. 

There is no right answer to what this value should be. If you set it to a very high number (say 5000) then you will use memory on the server and during a connection loss you will have more messages that need to be retried. If you set it too low you will basically end up with a maximum performance that is dictated by the latency of the round trip between the client and the server. A setting of 100 will allow 100 messages to be "queued" but not acknowledged with the client. This value in most systems will hit "the law of diminishing returns" very quickly. You will likely see a large increase from 5 to 20 but a small increase from 200-500 if any.

Turning off autoack and boosting the number of messages acknowledged is another important config point if you are going for performance. When you set autoack messages are acknowledged as they are processed and they are acknowledged one message at a time. If you handle acknowledgements manually you can acknowledge batches of messages (say 20 at a time) back to the server. 

<span class ="note">If you acknowledge in batches larger than your buffersize your subscription will stop sending messages as there will be no free slots to put more messages in.</span>

Using manual acknowledgements will also allow you to use multiple threads if you wish in the processing of your messages from the subscription as opposed to running in a single threaded environment or using a consumer/thread. To enable manual acknowledgements pass "false" for the autoAck parameter on the ConnectToPersistentSubscription method. When you decide to ack a message or a batch of messages you would then call 


```csharp
        public void NotifyEventsProcessed(Guid[] processedEvents)

        public void NotifyEventsFailed(Guid[] processedEvents, PersistentSubscriptionNakEventAction action, string reason)

```

in ordeer to Ack (or Nak) a group of messages, processedEvents represents the ids of the events you are Ack/Naking.

###Checkpointing

The next important configuration area is how often the subscription will "checkpoint". Checkpointing is a process where the subscription will mark in a persistent fashion how far along it has come. If you have a server failure or a restart if running on a single node, the persistent subscription will revert to its last known checkpoint.

Checkpointing can cause performance problems as to write a checkpoint causes a write within the system. You can imagine 10 persistent subscriptions all checkpointing every message (say 100/second) and you quickly have 1000 writes/second happening on your nodes. The checkpointing behaviour is however entirely configurable.

<table>
    <thead>
        <tr>
            <th>Member</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><code>CheckPointAfter(TimeSpan time)</code></td>
            <td>The amount of time the system should try to checkpoint after.</td>
        </tr>
        <tr>
            <td><code>MinimumCheckPointCountOf(int count)</code></td>
            <td>The minimum number of messages to write a checkpoint for.</td>
        </tr>
       <tr>
            <td><code>MaximumCheckPointCountOf(int count)</code></td>
            <td>The maximum number of messages not checkpointed before forcing a checkpoint.</td>
        </tr>
    </tbody>
</table>

The three configuration points above operate together to provide the configuration of checkpointing. The way the logic works is relatively simple, checkpoints are looked to be written in two places. The first in on a timer which is defined by CheckPointAfter. The second is anytime an ack is received.

The logic with the minimum and maximum controls when checkpoints should be written. As an example if you have a minumum check point count of 3 and there are currently 2 uncheckpointed messages neither case will write a checkpoint (there must be an increment of 3 to care). When acking a message if maximum is reached a checkpoint will be written immediately. A common use case of this might be to say (for a slow stream)

CheckPointAfter = 1 second
MinimumCheckPoint = 3 (if we retry 3 messages its not a big deal during failover)
MaximumCheckPoint = 10

Remember however that there is a tradeoff between how often you write checkpoints and the likelyhood of duplicated messages on a failover.

###Internal Buffer Sizes

There are a few configurable internal buffers for a persistent subscription. Tweaking the sizes of these buffers can help in reaching optimal performance and minimal memory footprint.

<table>
    <thead>
        <tr>
            <th>Member</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><code>WithLiveBufferSizeOf(int count)</code></td>
            <td>The size of the live buffer (in memory) before resorting to paging.</td>
        </tr>
        <tr>
            <td><code>WithReadBatchOf(int count)</code></td>
            <td>The size of the read batch when in paging mode.</td>
        </tr>
        <tr>
            <td><code>WithBufferSizeOf(int count)</code></td>
            <td>The number of messages that should be buffered when in paging mode.</td>
        </tr>
        </tr>
    </tbody>
</table>

The LiveBufferSize is the number of live messages on the subscription that you are willing to buffer before falling back to paging mode where the subscription will read messages from the stream. This buffer is also used when catching up as a certain count of live messages will be cached and therefore not needed to be read from the stream. The appropriate size of this cache depends on how the throughput of your stream ideally you want it to be large enough that you will not fall back to paging but you also want to minimize memory usage. It defaults to 500 messages.

There is another BufferSize which is the number of cached messages that are allowed during catch up. The subscription will be reading pages of data from the stream and putting them in this buffer asynchronously for the subscription to push to clients. If this buffer is too small the subscription can end up in a state where there are no messages to push to clients and the clients are forced to wait for the read to complete to receive messages. Again the tradeoff here is between memory used and speed during paging. The default value is 500.

The last important configuration point here is the size of the read of a stream when filling the buffer. This is only important during paging (during live it will receive from the live data). This controls the batch size of the reads. If this value is too big reads can be very slow (obviously this also depends on the size of your events). By default this value is 20 and probably should sit on a high end of 100-200.

###Performance Testing

As with anything the best way of "getting things right" is by going through simulations. You can see all of the above buffers etc in the status of your subscription in the administrator UI. 

There are two kinds of testing that are important with persistent subscriptions. The first is live performance. Generally the best way to do this is to simulate some amount of data being written into the subscription. Then setup subscribers on the stream and watch how the subscription reacts. Is it switching from live mode to paging mode? If so this means that the subscription is not keeping up with the amount of data being pushed in. It may be configuration changes that are needed or it may be that the actual subscribers are too slow, enabling extra-statistics can tell you more about the actual subscribers.

The next test is to run in paging mode (eg a replay). For this have a stream that already has many events in it and create a new subscription group with StartFromBeginning. You will see how the group does on a stream that is already filled with events running in paging mode. Again watch the UI and see how the subscription is behaving. The explanations above should go a long way towards figuring out where your performance problems may be occuring.