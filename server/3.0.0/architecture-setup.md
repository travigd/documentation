---
title: "Architecture Setup"
section: "Server"
version: 3.0.0
---

## Choices

The single largest chocie to make when setting up the Event Store is how you want security to work. Do you want to simply lock down the entire Event Store or do you want to use per-stream Access Control Lists? The answer to this question affects greatly how you deal with intermediary caching over HTTP as per-stream access control lists require setting caching to private see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.9.1

The setting of caching to private will cause many more requests to come directly to the Event Store as opposed to being picked up by faster intermediaries. Just locking the streams down as a whole however can be done much more inexpensively (and there is a hybrid solution).

## Lock Down Whole Event Store

In order to lock down the whole node the general idea is to not use security within the Event Store itself. Instead bind the Event Store to the localhost (127.0.0.1) interface. Then install a reverse proxy such as nginx or varnish on the public IP. Configure login credentials with the reverse proxy. Most support varying authentication schemes including LDAP/OAuth and Files.

The reverse proxy will be your public interface. Internally it will handle the authenticaion and route requests to the Event Store. The Event Store is only accessible through the localhost adapter and is not exposed publicly.

The locally running reverse proxy will also be allowed to cache responses. Reverse proxies will be much more performant than calling into the Event Store directly.

## Lock Down Streams with ACLs

The Event Store itself supports internal authentication. If you want to use it’s internal authentication you can expose it directly on a port. All Authentication will be handled by the Event Store. 

As the Event Store itself is handling all security requests it will have all information about users. This information can be used to check Access Control Lists of streams to allow for very fine grained control of security. This will however cause many more requests to need to get served internally by the Event Store and will be less performant.

## Hybrid Options

Even if using a reverse proxy in a trusted solution like above you can support external authentication from the Event Store itself. This can be done but turning on the trusted intermediary option in your config. This allows the intermediary to write a header with the user information that the Event Store will use. There is further discussion on this in the [HTTP headers section] (Optional-Http-Headers).