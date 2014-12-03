---
layout: docs
title: "Stream Metadata"
---

Every stream in the event store has metadata associated with it. The Event Store itself supports some values being set in the metadata and you can write your own arbitrary data into stream metadata if you wish (such as how often to snapshot for your own code). All names starting with `$` are however a reserved space for internal settings. The currently supported internal settings are:

* `$maxAge` maxAge will setup a sliding window based on dates. When data reaches a certain age it will disappear automatically from the stream and will be considered eligible for scavenging. This value is set as an integer representing the number of seconds. This value must be >=1.

* `$maxCount` maxCount will setup a sliding window based on the number of items in the stream. When data reaches a certain length it will disappear automatically from the stream and will be considered eligible for scavenging. This value is set as an integer representing the count of items. This value must be >= 1.

* `$cacheControl` cacheControl controls the cache of the head of a stream. Most uris in a stream are infinitely cacheable but the head by default will not cache. It may be preferable in some situations to set a small amount of caching on the head to allow intermediaries to handle polls (say 10 seconds). The argument is an integer representing the seconds to cache. This value must be >= 1.

Security access control lists are also included in the `$acl` section of the stream metadata.

* `$r` The list of users with read permissions

* `$w` The list of users with write permissions

* `$d` The list of users with delete permissions

* `$mw` The list of users with write permissions to stream metadata

* `$mr` The list of users with read permissions to stream metadata

Example:

```json
{
    "$acl" {
         "$r" : "ouro",
         "$w" : "ouro",
         "$d" : "$admins"
    }
}
```