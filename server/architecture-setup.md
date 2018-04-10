---
outputFileName: index.html
---

# HTTP Architecture Setup
<!-- TODO: Is the title descrptive? -->

## Authentication Options

There are two main options for authentication with Event Store. You secure Event Store itself, or you can use per-stream [Access Control Lists](~/server/users-and-access-control-lists.md) to give more fine-grained control on which users can access which data. You can also take a hybrid approach that mixes the two.

### Secure Event Store

To secure Event Store, you bind the server to the localhost (127.0.0.1) interface and then install a reverse proxy such as [nginx](http://nginx.org) or [Varnish](https://www.varnish-cache.org) on the public IP. You can find an example of setting up Event Store with Varnish [here](../server/setting-up-varnish-in-linux.md).

The reverse proxy will be your public interface. Internally it will handle the authentication and route requests to Event Store. Event Store is only accessible through the localhost adapter and is not exposed publicly. The locally running reverse proxy will be allowed to cache responses, and because of this, reverse proxies will be more performant than calling Event Store directly.

### Secure Streams with ACLs

Event Store supports internal authentication, you can expose Event Store directly on a port, and Event Store handles all authentication.

As Event Store is handling all security requests it will have all information about users. Event Store uses this information to check the Access Control Lists of streams and allows for fine-grained control of security. This will cause more internal requests served by Event Store and thus will be less performant.

> [!NOTE]
> Per-stream access control lists require setting caching to private to ensure data is not cached in a shared cache, read [this article](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.9.1) for more information

### Hybrid Option

Even if you use a reverse proxy as above, you can support external authentication from Event Store itself. You do this by enabling the trusted intermediary option in your configuration. This allows the intermediary to write a header with the user information that Event Store will use. You can find how to do this in the [HTTP headers section](../http-api/optional-http-headers/index.md).

## Security with SSL

### Windows

Setting up SSL in Windows is the same as setting up any `httplistener` in Windows for SSL. You can find many examples of this can online, and we recommend [this guide from Damir Dobric](http://developers.de/blogs/damir_dobric/archive/2006/08/01/897.aspx)

### Linux

Setting up SSL in Linux is the same as setting up any mono `httplistener` in Linux for SSL. You can find many examples of this can online, and we recommend [this guide from Joshua Perina](http://joshua.perina.com/geo/post/using-ssl-https-with-mono-httplistener). This method will likely work for other systems such as OpenBSD as well.
