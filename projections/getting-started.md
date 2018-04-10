---
outputFileName: index.html
---

# Getting Started

You can create projections in one of 2 ways. You can supply them to Event Store directly via the HTTP API, or you can use the administration UI which provides a section for authoring projections.

## Starting and Configuring Event Store for Projections

The following configuration starts Event Store with all the projection modes enabled (user and system defined) and uses an in-memory database which is suitable for development purposes.

```powershell
EventStore.ClusterNode.exe --run-projections=all --mem-db
```

You should now have an Event Store database up and running with projections enabled. To verify open _<http://localhost:2113>_ in your browser. To login, use the credentials, `username: admin` and `password: changeit`.

Once you are logged into the administration UI, you should see a _projections_ tab at the top and after clicking it, you should see the 4 system projections in a `Stopped` state.

You can separately query the state of all the projections using the HTTP API.

### [Request](#tab/tabid-1)

```bash
curl -i http://localhost:2113/projections/any -H "accept:application/json" | grep -E 'effectiveName|status'
```

### [Response](#tab/tabid-2)

The response is a list of all known projections and useful information about them.

```json
"effectiveName": "$streams"
"status": "Stopped"
"statusUrl": "http://localhost:2113/projection/$streams"

"effectiveName": "$stream_by_category"
"status": "Stopped"
"statusUrl": "http://localhost:2113/projection/$stream_by_category"

"effectiveName": "$by_category"
"status": "Stopped"
"statusUrl": "http://localhost:2113/projection/$by_category"

"effectiveName": "$by_event_type"
"status": "Stopped"
"statusUrl": "http://localhost:2113/projection/$by_event_type"
```

* * *

## Setup Sample Data

The following snippets will provide you with some sample data which we will be using throughout this getting started guide.

Filename: _shoppingCart-b989fe21-9469-4017-8d71-9820b8dd1164.json_

Contents:

```json
[
    {
      "eventId"    : "b989fe21-9469-4017-8d71-9820b8dd1164",
      "eventType"  : "ItemAdded",
      "data"       : {
         "Description": "Xbox One S 1TB (Console)",
      },
      "metadata"   : {
         "TimeStamp": "2016-12-23T08:00:00.9225401+01:00"
      }
    },
    {
      "eventId"    : "b989fe21-9469-4017-8d71-9820b8dd1174",
      "eventType"  : "ItemAdded",
      "data"       : {
         "Description": "Gears of War 4",
      },
      "metadata"   : {
         "TimeStamp": "2016-12-23T08:05:00.9225401+01:00"
      }
    }
]
```

Filename: _shoppingCart-b989fe21-9469-4017-8d71-9820b8dd1165.json_

Contents:

```json
[
    {
      "eventId"    : "b989fe21-9469-4017-8d71-9820b8dd1165",
      "eventType"  : "ItemAdded",
      "data"       : {
         "Description": "Xbox One S 500GB (Console)"
      },
      "metadata"   : {
         "TimeStamp": "2016-12-23T09:00:00.9225401+01:00"
      }
    },
    {
      "eventId"    : "b989fe21-9469-4017-8d71-9820b8dd1175",
      "eventType"  : "ItemAdded",
      "data"       : {
         "Description": "Xbox One Elite Controller"
      },
      "metadata"   : {
         "TimeStamp": "2016-12-23T09:05:00.9225401+01:00"
      }
    }
]
```

Filename: _shoppingCart-b989fe21-9469-4017-8d71-9820b8dd1166.json_

Contents:

```json
[
    {
      "eventId"    : "b989fe21-9469-4017-8d71-9820b8dd1166",
      "eventType"  : "ItemAdded",
      "data"       : {
         "Description": "Xbox One S Minecraft Edition (Console)"
      },
      "metadata"   : {
         "TimeStamp": "2016-12-23T10:00:00.9225401+01:00"
      }
    },
    {
      "eventId"    : "b989fe21-9469-4017-8d71-9820b8dd1176",
      "eventType"  : "ItemAdded",
      "data"       : {
         "Description": "Fifa 2016 (Xbox)"
      },
      "metadata"   : {
         "TimeStamp": "2016-12-23T10:05:00.9225401+01:00"
      }
    }
]
```

Filename: _shoppingCart-b989fe21-9469-4017-8d71-9820b8dd1167.json_

Contents:

```json
[
    {
      "eventId"    : "b989fe21-9469-4017-8d71-9820b8dd1167",
      "eventType"  : "ItemAdded",
      "data"       : {
         "Description": "Xbox One Elite (Console)"
      },
      "metadata"   : {
         "TimeStamp": "2016-12-23T10:00:00.9225401+01:00"
      }
    }
]
```

```bash
curl -i -d @"shoppingCart-b989fe21-9469-4017-8d71-9820b8dd1164.json" "http://127.0.0.1:2113/streams/shoppingCart-b989fe21-9469-4017-8d71-9820b8dd1164" -H "Content-Type:application/vnd.eventstore.events+json"

curl -i -d @"shoppingCart-b989fe21-9469-4017-8d71-9820b8dd1165.json" "http://127.0.0.1:2113/streams/shoppingCart-b989fe21-9469-4017-8d71-9820b8dd1165" -H "Content-Type:application/vnd.eventstore.events+json"

curl -i -d @"shoppingCart-b989fe21-9469-4017-8d71-9820b8dd1166.json" "http://127.0.0.1:2113/streams/shoppingCart-b989fe21-9469-4017-8d71-9820b8dd1166" -H "Content-Type:application/vnd.eventstore.events+json"

curl -i -d @"shoppingCart-b989fe21-9469-4017-8d71-9820b8dd1167.json" "http://127.0.0.1:2113/streams/shoppingCart-b989fe21-9469-4017-8d71-9820b8dd1167" -H "Content-Type:application/vnd.eventstore.events+json"
```

## Writing your first projection

Finally you can get to writing the projection itself, you can find the user defined projection's API [here](user-defined-projections.md).

Start with a simple projection that will count the number of XBox One Ss that customers added to their shopping carts.

A Projection starts with a selector, in this case `fromAll()`. Another possibility is `fromCategory({category}` which we will discuss later, but for now, `fromAll` should do.

The second part of the projection is a set of filters and there is a special filter called `$init` that provides the ability to setup some initial state. You want to start the counter from 0 and each time you observe the `ItemAdded` event for an 'Xbox One S' you want to increment this counter.

Here is the projection so far

Filename: _xbox-one-s-counter.json_

Contents:

```json
fromAll()
.when({
    $init: function(){
        return {
            count: 0
        }
    },
    ItemAdded: function(s,e){
        if(e.body.Description.indexOf("Xbox One S") >= 0){
            s.count += 1;
        }
    }
})
```

You can create the projection by calling to the API and providing it with the definition of the projection. Here you make a decision on how to run the projection. You are declaring that you want the projection to start from the beginning and keep running into the future.

You can find more information about how to interact with projections in the [API section](api.md).

```bash
curl -i --data-binary "@xbox-one-s-counter.json" http://localhost:2113/projections/continuous?name=xbox-one-s-counter%26type=js%26enabled=true%26emit=true%26trackemittedstreams=true -u admin:changeit
```

You should have received a '201 Created response' from Event Store, which means that the projection was created successfully. You can confirm that the projection is running by issuing a status request.

### [Request](#tab/tabid-3)

```bash
curl -i http://localhost:2113/projection/xbox-one-s-counter | grep status
```

### [Response](#tab/tabid-4)

The response should resemble the following.

```bash
"status": "Running",
"statusUrl": "http://localhost:2113/projection/xbox-one-s-counter",
```

* * *

## Querying for the state of the projection

Now the projection is running, you can query the state of the projection. You can query the state of the projection by issuing yet another request. For a projection that has a single state (more on this later), the request should resemble the following.

### [Request](#tab/tabid-5)

```bash
curl -i http://localhost:2113/projection/xbox-one-s-counter/state
```

### [Response](#tab/tabid-6)

Which should return the state (JSON by default).

```json
{
  "count":3
}
```

* * *

## Writing to streams from Projections

The above gives you the correct result, but requires you to poll for the state of a projection. What if you wanted to be notified of state updates via subscriptions?

## Output State

You could configure the projection to output the state to a stream by calling the `outputState()` method on the projection which by default will produce a `$projections-{projection-name}-result` stream.

Filename: _xbox-one-s-counter-outputState.json_

```json
fromAll()
.when({
    $init: function(){
        return {
            count: 0
        }
    },
    ItemAdded: function(s,e){
        if(e.body.Description.indexOf("Xbox One S") >= 0){
            s.count += 1;
        }
    }
}).outputState()
```

To update the projection, you issue the following request.

```bash
curl -i -X PUT --data-binary "@xbox-one-s-counter-outputState.json" http://localhost:2113/projection/xbox-one-s-counter/query?emit=yes -u admin:changeit
```

You can now read the events in the result stream by issuing a read request.

### [Request](#tab/tabid-7)

```bash
curl -i http://localhost:2113/streams/%24projections-xbox-one-s-counter-result\?embed\=body -H "accept:application/json" -u admin:changeit | grep data
```

### [Response](#tab/tabid-8)

The response should resemble the following.

```json
"data": "{\"count\":3}",
"data": "{\"count\":2}",
"data": "{\"count\":1}",
```

* * *

You can configure the name of the state stream via the projection options:

```json
options({
  resultStreamName: "xboxes"
})
```

## Number of items per shopping cart

The above example relied on a global state for the projection, but what if you wanted a simple count of the number of items in the shopping cart per shopping cart.

There is a built in projection that gives you the ability to select events from a particular list of streams which is the `$by_category` projection. Enable this projection now.

```bash
curl -i -d{} http://localhost:2113/projection/%24by_category/command/enable -u admin:changeit
```

The projection will link events from existing streams to new streams by splitting the stream name by a separator. The projection is configurable and you can specify the position of where it needs to split the stream `id` and provide your own separator.

For example, by default the category is determined by splitting the stream `id` by a dash. The category is the first string.

| Stream Name        | Category                               |
| ------------------ | -------------------------------------- |
| shoppingCart-54    | shoppingCart                           |
| shoppingCart-v1-54 | shoppingCart                           |
| shoppingCart       | _No category as there is no separator_ |

With the projection enabled, you can continue with defining the projection. You want to define a projection that will produce a count per stream for a category but the state needs to be per stream.

Make use of the built in system projection `$by_category` that enables the use of the `fromCategory` API method.

Filename: _shopping-cart-counter.json_

```json
fromCategory('shoppingCart')
.foreachStream()
.when({
    $init: function(){
        return {
            count: 0
        }
    },
    ItemAdded: function(s,e){
        s.count += 1;
    }
})
```

Once again, you can create the projection by issuing an HTTP request:

```bash
curl -i --data-binary "@shopping-cart-counter.json" http://localhost:2113/projections/continuous?name=shopping-cart-item-counter%26type=js%26enabled=true%26emit=true%26trackemittedstreams=true -u admin:changeit
```

## Querying for the state of the projection by partition

Querying for the state of the projection is different due to the way you have partitioned the projection. You have to specify the partition you are interested in and it's the name of the stream.

### [Request](#tab/tabid-9)

```bash
curl -i http://localhost:2113/projection/shopping-cart-item-counter/state?partition=shoppingCart-b989fe21-9469-4017-8d71-9820b8dd1164
```

### [Response](#tab/tabid-10)

Which returns the state (JSON by default).

```bash
{
  "count":2
}
```

* * *
