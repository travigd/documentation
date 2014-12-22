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

## Creating a Subscription Group

The first step of dealing with a subscription group is that it must be created.

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



## Deleting a Subscription Group

## Updating a Subscription Group

## Connecting to a Subscription Group