---
title: "Competing Consumers Introduction"
section: "Introduction"
---

Beginning with version 3.0.2 a new subscription model is available in Event Store. This model is known as competing consumers and is very similar to subscriptions models you may have dealt with in the past such as AMQP. This document serves as a high level overview of the functionality, what it can provide, and when you may want to use it.

<span class="note">Competing Consumers only exists in version 3.0.2 and above. Please see specific version documentation in order to gain more details on methods names etc.</span>

## What is Competing Consumers

Competing Consumers is another subscription model that is available, it differs in usage from the Subscribe operation or from a CatchUpSubscription in terms of how it works. SubscribeToStream as example will read the events from this point forward that happen in a stream. A CatchUpSubscription will read all the events in a stream to your client from a given point.

Both a Subscription and a CatchupSubscription use a model where the client holds the state of the subscription much like with a blog client your client remembers the last post that you have read. The server does not hold any state particular to a given client.  Competing Consumers operate differently, with Competing Consumers the server remembers the state of the subscription. This allows for many different modes of operations compared to a subscription where the client holds the subscription state.

The first step in using Competing Consumers is to 