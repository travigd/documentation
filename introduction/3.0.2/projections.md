---
title: "Projections and Queries"
section: "Introduction"
version: "3.0.2"
---


#### Example queries

```JavaScript
fromStream('user-100').
    when({
        'userCreated' : function(state, ev) {
              var isGenerated = ev.body['generated'];
              var userId = ev.body['id'];
              
              if(isGenerated === true) {
                   emit('generatedUsers', 'generatedUser', {'id' : userId})
              }
         }
    });
```

```JavaScript
fromCategory('user')
  .foreachStream()
  .when({
    '$init': function(state, ev) {
      return { userCount: 0 }
    },
    'userCreated': function(state, ev) {
      state.userCount++
    }
  })
```

------------


##### fromStream 
Returns one stream to query from
```JavaScript
fromStream('streamName')
```

-----

##### fromStreams
Returns a list of streams
```JavaScript  
fromStreams(['stream1', 'stream2'])
```

-----

##### fromCategory
Returns a list of streams in a category

A category is the first part of the stream name before any dashes.

For Example:

Stream Name  | Category
------------- | -------------
user-54  | user
user-v1-54  | v1
users | users

```JavaScript  
fromCategory('user')
```
