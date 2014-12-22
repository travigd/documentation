---
title: "Competing Consumers"
section: ".NET API"
version: 3.1.0-pre
---

This document walks through the .NET client API for setting up and consuming competing consumer subscription groups. For an overview on competing consumers and how they relate to other subscription types please see [the overview document](../../../introduction/competing-consumers)

#Methods

##Creating a Persistent Subscription

```csharp
Task<PersistentSubscriptionCreateResult> CreatePersistentSubscriptionAsync(string stream, string groupName, PersistentSubscriptionSettings settings, UserCredentials credentials);
```

##Updating a Persistent Subscription

```csharp
Task<PersistentSubscriptionUpdateResult> UpdatePersistentSubscriptionAsync(string stream, string groupName, PersistentSubscriptionSettings settings, UserCredentials credentials);
```

##Deleting a Persistent Subscription

```csharp
Task<PersistentSubscriptionDeleteResult> DeletePersistentSubscriptionAsync(string stream, string groupName, UserCredentials userCredentials = null);
```

##Connecting to a Persistent Subscription

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

##Persistent Subscription Settings

Both the Create and Update methods take a PersistentSubscriptionSettings object as a parameter. This object is used to provide the settings for the persistent subscription. There is also a fluent builder for these options that can be located using the Create() method. The following table shows the options that can be set on a persistent subscription.

<table>
    <thead>
        <tr>
            <th>Member</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><code>ResolveLinkTos</code></td>
            <td>Tells the subscription to resolve link events.</td>
        </tr>
        <tr>
            <td><code>DoNotResolveLinkTos</code></td>
            <td>Tells the subscription to not resolve link events.</td>
        </tr>
        <tr>
            <td><code>PreferRoundRobin</code></td>
            <td>If possible prefer to round robin between the connections with messages (if not possible will use next available)</td>
        </tr>
        <tr>
            <td><code>PreferDispatchToSingle</code></td>
            <td>If possible prefer to dispatch to a single connection (if not possible will use next available)</td>
        </tr>
        <tr>
            <td><code>StartFromBeginning</code></td>
            <td>Start the subscription from the first event in the stream.</td>
        </tr>
        <tr>
            <td><code>StartFrom(int position)</code></td>
            <td>Start the subscription from the position-th event in the stream.</td>
        </tr>
        <tr>
            <td><code>StartFromCurrent</code></td>
            <td>Start the subscription from the current position.</td>
        </tr>
        <tr>
            <td><code>WithMessageTimeoutOf(TimeSpan timeout)</code></td>
            <td>Sets the timeout for a client before the message will be retried.</td>
        </tr>
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
            <td>The maximum number of messages not checkpointed before forcing a checkpoint</td>
        </tr>
        <tr>
            <td><code>WithMaxRetriesOf(int count)</code></td>
            <td>Sets the number of times a message should be retried before being considered a bad message</td>
        </tr>
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
        <tr>
            <td><code>MinimumCheckPointCountOf(int count)</code></td>
            <td>The minimum number of messages to write a checkpoint for.</td>
        </tr>
       <tr>
            <td><code>MaximumCheckPointCountOf(int count)</code></td>
            <td>The maximum number of messages not checkpointed before forcing a checkpoint</td>
        </tr>
        <tr>
            <td><code>WithMaxRetriesOf(int count)</code></td>
            <td>Sets the number of times a message should be retried before being considered a bad message</td>
        </tr>
        <tr>
            <td><code>WithLiveBufferSizeOf(int count)</code></td>
            <td>The size of the live buffer (in memory) before resorting to paging.</td>
        </tr>
    </tbody>
</table>

##Creating a Subscription Group

The first step of dealing with a subscription group is that it must be created. Note you will get an error if you attempt to create a subscription group multiple times.

<span class="note">Normally the creating of the subscription group is not done in your general executable code. Instead it is normally done as a step during an install or as an admin task when setting things up. You should assume the subscription exists in your code.</span>

```csharp
PersistentSubscriptionSettings settings = PersistentSubscriptionSettings.Create()
                                                                .DoNotResolveLinkTos()
                                                                .StartFromCurrent();
_result = _conn.CreatePersistentSubscriptionAsync(_stream, 
												  "agroup", 
												  settings, 
												  MyCredentials).Result;                            
```



## Updating a Subscription Group

```csharp
PersistentSubscriptionSettings settings = PersistentSubscriptionSettings.Create()
                                                                .DoNotResolveLinkTos()
                                                                .StartFromCurrent();
_result = _conn.UpdatePersistentSubscriptionAsync(_stream, 
												  "agroup", 
												  settings, 
												  MyCredentials).Result;                            
```


## Deleting a Subscription Group


## Connecting to a Subscription Group