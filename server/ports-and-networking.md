---
title: "Ports and networking"
section: "Server"
version: "4.0.2"
---

## Single Node

If you run Event Store as a single node, it will only use two ports. The first port is the external HTTP port. Event Store uses this port for both the client HTTP APIs and for the management HTTP interface. The default external HTTP port is 2113. The second port used is the TCP interface for clients connecting over the client API, and the default for the port is 1113.

Event Store in Windows will try to add access via `http.sys` automatically for the 2113 port.

You should ensure that these ports are open and allowed via a firewall if you are using a firewall on the machine.

## Cluster Node

When running in cluster mode the networking for Event Store is more complex. Cluster mode requires 4 ports to run. The ports are for internal HTTP, internal TCP, external HTTP, and external TCP.

The internal and external interfaces allow for separation of traffic. The internal network is where all cluster communications runs while the external interfaces is where all client communications runs. This allows for interesting setups such as putting internal communications on a different network than external client communications. You may wish to do this for many reasons including putting communications on separate NICs, locking down internal communications from a security perspective, or for security purposes. A good example of this might be when allowing clients over HTTP to talk directly to Event Store, you can move internal communications to a separate network to ensure the management interface and internal operations are not accessible from the outside.

The external TCP and HTTP are similar to the HTTP and TCP ports of a single node deploy. Event Store runs Client requests over the HTTP API through the external HTTP port. You can run without the management API on the external interface (internal only). The external and the internal interfaces support the gossip protocol. You can control whether the admin interface is available on the external HTTP interface using the `admin-on-ext` [option]({{site.baseurl}}/server/command-line-arguments). You can control whether gossip is enable on external with the `gossip-on-ext` [option]({{site.baseurl}}/server/command-line-arguments) (though you normally want it).

You configure the internal TCP and HTTP ports in the same way as the external. All internal communications for the cluster happen over these interfaces. Elections and internal gossip happen over HTTP. Replication and forwarding of client requests happens over the TCP channel.

When setting up a cluster the nodes must be able to reach each other over both the internal HTTP channel and the internal TCP channel. You should ensure that these ports are open on firewalls on the machines and between the machines.

## Heartbeat Timeouts

Event Store uses heartbeats over all TCP connections to attempt to discover dead clients and nodes. Setting heartbeat timeouts is hard, set them too short and you will get false positives, set them too long and discovery of dead clients and nodes becomes slower.

Each heartbeat has two points of configuration. The first is the 'interval', this represents how often the system should consider a heartbeat. There will not be a heartbeat sent for every interval. Heartbeats work by saying "if I have not received something from this node within the last interval send a heartbeat request". As such on a busy system you will not send any heartbeats. The second point of configuration is the 'timeout', when sending a heartbeat, how long do you wait for the client or node to respond to the heartbeat request.

Varying environments want drastically different values for these settings. While low numbers work well on a LAN they tend to not work well in the cloud. The defaults are likely fine on a LAN, in the cloud consider a setting of interval 5000ms and timeout 1000ms which should be fine for most installations.

<span class="note--warning">If in question err on the side of higher numbers, it will add a small period of time to discover a dead client or node and is better than the alternative, which is false positives.</span>

## Advertise As

There are times when due to NAT <!-- TODO: Which is? What I think it is --> or other reasons a node may not be bound to the address it is reachable from other nodes as. As an example the machine has an IP address of 192.168.1.13 but the node is visible to other nodes as 10.114.12.112.

The option `advertise-as` allows you to tell the node that even though it is bound to a given address it should not gossip that address as its address. Instead it will use the address that you tell it to use. In the example above you would configure

```bash
--ext-ip 192.168.1.13 --advertise-as 10.114.12.112
```

Or use the equivalent configuration via environment variables or a configuration file.
