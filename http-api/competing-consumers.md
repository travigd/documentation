---
title: Competing Consumers
section: HTTP API
version: 4.0.2
---

This document explains how to use HTTP API for setting up and consuming competing consumer subscription groups. For an overview on competing consumers and how they relate to other subscription types please see the [overview document]({{site.baseurl}}/introduction/competing-consumers).

> [!NOTE]
>
The Administration UI includes a <em>Competing Consumers</em> section where a user is able to create, update, delete and view subscriptions and their statuses.


## Creating a Persistent Subscription
                                                        |
## Updating a Persistent Subscription

## Deleting a Persistent Subscription

## Reading a stream via a Persistent Subscription

### Response

```json
{
  "title": "All Events Persistent Subscription",
  "id": "http://localhost:2113/subscriptions/newstream/competing_consumers_group1",
  "updated": "2015-12-02T09:17:48.556545Z",
  "author": {
    "name": "EventStore"
  },
  "headOfStream": false,
  "links": [{
    "uri": "http://localhost:2113/subscriptions/newstream/competing_consumers_group1/ack%3Fids=c322e299-cb73-4b47-97c5-5054f920746f",
    "relation": "ackAll"
  }, {
    "uri": "http://localhost:2113/subscriptions/newstream/competing_consumers_group1/nack%3Fids=c322e299-cb73-4b47-97c5-5054f920746f",
    "relation": "nackAll"
  }, {
    "uri": "http://localhost:2113/subscriptions/newstream/competing_consumers_group1/1%3Fembed=None",
    "relation": "previous"
  }, {
    "uri": "http://localhost:2113/subscriptions/newstream/competing_consumers_group1",
    "relation": "self"
  }],
  "entries": [{
    "title": "1@newstream",
    "id": "http://localhost:2113/streams/newstream/1",
    "updated": "2015-12-02T09:17:48.556545Z",
    "author": {
      "name": "EventStore"
    },
    "summary": "SomeEvent",
    "links": [{
      "uri": "http://localhost:2113/streams/newstream/1",
      "relation": "edit"
    }, {
      "uri": "http://localhost:2113/streams/newstream/1",
      "relation": "alternate"
    }, {
      "uri": "http://localhost:2113/subscriptions/newstream/competing_consumers_group1/ack/c322e299-cb73-4b47-97c5-5054f920746f",
      "relation": "ack"
    }, {
      "uri": "http://localhost:2113/subscriptions/newstream/competing_consumers_group1/nack/c322e299-cb73-4b47-97c5-5054f920746f",
      "relation": "nack"
    }]
  }]
}
```

## Acknowledgements

Clients must acknowledge (or not acknowledge) messages in the competing consumer model. If the client fails to respond in the given timeout period, the message will be retried. You should use the `rel` links in the feed for acknowledgements not bookmark URIs as they are subject to change in future versions.

For example:

```http
{
  "uri": "http://localhost:2113/subscriptions/newstream/competing_consumers_group1/ack/c322e299-cb73-4b47-97c5-5054f920746f",
  "relation": "ack"
}
```

### Ack multiple messages

| URI                                                                | Supported Content Types | Method |
| ------------------------------------------------------------------ | ----------------------- | ------ |
| `/subscriptions/{stream}/{subscription_name}/ack?ids={messageids}` | `application/json`      | POST   |

#### Query Parameters

| Parameter           | Description                                    |
| ------------------- | ---------------------------------------------- |
| `stream`            | The stream the persistent subscription is on.  |
| `subscription_name` | The name of the subscription group.            |
| `messageids`        | The ids of the messages that needs to be acked |

### Ack a single message

| URI                                                           | Supported Content Types | Method |
| ------------------------------------------------------------- | ----------------------- | ------ |
| `/subscriptions/{stream}/{subscription_name}/ack/{messageid}` | `application/json`      | POST   |

#### Query Parameters

| Parameter           | Description                                      |
| ------------------- | ------------------------------------------------ |
| `stream`            | The stream to the persistent subscription is on. |
| `subscription_name` | The name of the subscription group.              |
| `messageid`         | The id of the message that needs to be acked     |

<!-- TODO: Has this been explained? -->

### Nack multiple messages

| URI                                                                                 | Supported Content Types | Method |
| ----------------------------------------------------------------------------------- | ----------------------- | ------ |
| `/subscriptions/{stream}/{subscription_name}/nack?ids={messageids}?action={action}` | `application/json`      | POST   |

#### Query Parameters

| Parameter           | Description                                                                                                                                                                                                      |     |
| ------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --- |
| `stream`            | The stream to the persistent subscription is on.                                                                                                                                                                 |     |
| `subscription_name` | The name of the subscription group.                                                                                                                                                                              |     |
| `action`            | <ul><li>**Park**: Don't retry the message, park it until a request is sent to reply the parked messages<li>**Retry**: Retry the message<li>**Skip**: Discard the message<li>**Stop**: Stop the subscription</ul> |     |
| `messageid`         | The id of the message that needs to be acked                                                                                                                                                                     |     |

### Nack a single message

| URI                                                                            | Supported Content Types | Method |
| ------------------------------------------------------------------------------ | ----------------------- | ------ |
| `/subscriptions/{stream}/{subscription_name}/nack/{messageid}?action={action}` | `application/json`      | POST   |

## Replaying parked messages

| URI                                                        | Supported Content Types | Method |
| ---------------------------------------------------------- | ----------------------- | ------ |
| `/subscriptions/{stream}/{subscription_name}/replayParked` | `application/json`      | POST   |

## Getting information for all subscriptions

| URI              | Supported Content Types | Method |
| ---------------- | ----------------------- | ------ |
| `/subscriptions` | `application/json`      | POST   |

### Response

```json
[
  {
    "links": [
      {
        "href": "http://localhost:2113/subscriptions/newstream/competing_consumers_group1/info",
        "rel": "detail"
      }
    ],
    "eventStreamId": "newstream",
    "groupName": "competing_consumers_group1",
    "parkedMessageUri": "http://localhost:2113/streams/$persistentsubscription-newstream::competing_consumers_group1-parked",
    "getMessagesUri": "http://localhost:2113/subscriptions/newstream/competing_consumers_group1/1",
    "status": "Live",
    "averageItemsPerSecond": 0.0,
    "totalItemsProcessed": 0,
    "lastProcessedEventNumber": -1,
    "lastKnownEventNumber": 5,
    "connectionCount": 0,
    "totalInFlightMessages": 0
  },
  {
    "links": [
      {
        "href": "http://localhost:2113/subscriptions/another_newstream/competing_consumers_group1/info",
        "rel": "detail"
      }
    ],
    "eventStreamId": "another_newstream",
    "groupName": "competing_consumers_group1",
    "parkedMessageUri": "http://localhost:2113/streams/$persistentsubscription-another_newstream::competing_consumers_group1-parked",
    "getMessagesUri": "http://localhost:2113/subscriptions/another_newstream/competing_consumers_group1/1",
    "status": "Live",
    "averageItemsPerSecond": 0.0,
    "totalItemsProcessed": 0,
    "lastProcessedEventNumber": -1,
    "lastKnownEventNumber": -1,
    "connectionCount": 0,
    "totalInFlightMessages": 0
  }
]
```

## Getting information about the subscriptions for a stream

| URI                       | Supported Content Types | Method |
| ------------------------- | ----------------------- | ------ |
| `/subscriptions/{stream}` | `application/json`      | GET    |

### Response

```json
[
  {
    "links": [
      {
        "href": "http://localhost:2113/subscriptions/newstream/competing_consumers_group1/info",
        "rel": "detail"
      }
    ],
    "eventStreamId": "newstream",
    "groupName": "competing_consumers_group1",
    "parkedMessageUri": "http://localhost:2113/streams/$persistentsubscription-newstream::competing_consumers_group1-parked",
    "getMessagesUri": "http://localhost:2113/subscriptions/newstream/competing_consumers_group1/1",
    "status": "Live",
    "averageItemsPerSecond": 0.0,
    "totalItemsProcessed": 0,
    "lastProcessedEventNumber": -1,
    "lastKnownEventNumber": 5,
    "connectionCount": 0,
    "totalInFlightMessages": 0
  }
]
```

## Getting information about a specific subscription

| URI                                                | Supported Content Types | Method |
| -------------------------------------------------- | ----------------------- | ------ |
| `/subscriptions/{stream}/{subscription_name}/info` | `application/json`      | GET    |

### Response

```json
{
  "links": [{
      "href": "http://localhost:2113/subscriptions/newstream/competing_consumers_group1/info",
      "rel": "detail"
    },
    {
      "href": "http://localhost:2113/subscriptions/newstream/competing_consumers_group1/replayParked",
      "rel": "replayParked"
    }
  ],
  "config": {
    "resolveLinktos": false,
    "startFrom": 0,
    "messageTimeoutMilliseconds": 10000,
    "extraStatistics": false,
    "maxRetryCount": 10,
    "liveBufferSize": 500,
    "bufferSize": 500,
    "readBatchSize": 20,
    "preferRoundRobin": true,
    "checkPointAfterMilliseconds": 1000,
    "minCheckPointCount": 10,
    "maxCheckPointCount": 500,
    "maxSubscriberCount": 10,
    "namedConsumerStrategy": "RoundRobin"
  },
  "eventStreamId": "newstream",
  "groupName": "competing_consumers_group1",
  "status": "Live",
  "averageItemsPerSecond": 0.0,
  "parkedMessageUri": "http://localhost:2113/streams/$persistentsubscription-newstream::competing_consumers_group1-parked",
  "getMessagesUri": "http://localhost:2113/subscriptions/newstream/competing_consumers_group1/1",
  "totalItemsProcessed": 0,
  "countSinceLastMeasurement": 0,
  "lastProcessedEventNumber": -1,
  "lastKnownEventNumber": 5,
  "readBufferCount": 6,
  "liveBufferCount": 5,
  "retryBufferCount": 0,
  "totalInFlightMessages": 0,
  "connections": []
}
```
