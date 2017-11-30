---
title: "Setting up a Cluster using only Database Nodes (OSS)"
section: "Server"
version: "4.0.2"
---

Effective September of 2013 <!-- TODO: A version might be better --> all the clustering code for Event Store has been open sourced (under the normal BSD-3 license as the rest of the code). This document will look at how you can setup a highly available cluster using the open source components.

<!-- TODO: I think there's a much better way of saying all this -->

When setting up a cluster, you will generally want an odd number of nodes ads Event Store uses a quorum based algorithm to handle high availability.

## Running on the Same Machine

To start, you will set up three nodes running on a single machine. Run each of the commands below in its own console window, remember that you either need admin privileges or have setup ACLs with IIS if running under Windows (Unix-like operating systems need no configuration). Replace "127.0.0.1" with whatever IP address you want to run on.

<span class="note--warning">This must be an interface present on the machine.</span>

```powershell
start EventStore.ClusterNode.exe --mem-db --log .\logs\log1 --int-ip 127.0.0.1 --ext-ip 127.0.0.1 --int-tcp-port=1111 --ext-tcp-port=1112 --int-http-port=1113 --ext-http-port=1114 --cluster-size=3 --discover-via-dns=false --gossip-seed=127.0.0.1:2113,127.0.0.1:3113
start EventStore.ClusterNode.exe --mem-db --log .\logs\log2 --int-ip 127.0.0.1 --ext-ip 127.0.0.1 --int-tcp-port=2111 --ext-tcp-port=2112 --int-http-port=2113 --ext-http-port=2114 --cluster-size=3 --discover-via-dns=false --gossip-seed=127.0.0.1:1113,127.0.0.1:3113
start EventStore.ClusterNode.exe --mem-db --log .\logs\log3 --int-ip 127.0.0.1 --ext-ip 127.0.0.1 --int-tcp-port=3111 --ext-tcp-port=3112 --int-http-port=3113 --ext-http-port=3114 --cluster-size=3 --discover-via-dns=false --gossip-seed=127.0.0.1:1113,127.0.0.1:2113
```

You should now have three nodes running together in a cluster. If you kill one of the nodes, it will continue running. This binds to the loopback interface. To access Event Store from outside your machine, specify a different IP address for the `--ext-ip` parameter.

## Running on Separate Machines

Most importantly is understanding the "gossip seeds". You are instructing seed locations for when the node first starts and needs to begin gossiping. Any node can be a seed. By giving each node the other nodes you ensure that there will always be another node to gossip with if a quorum can be built. If you wanted to move this to run on three machines you would change the IPs on the command line to something such as:

```powershell
EventStore.ClusterNode.exe --mem-db --log c:\dbs\cluster\log1 --int-ip 192.168.0.1 --ext-ip 192.168.0.1 --int-tcp-port=1111 --ext-tcp-port=1112 --int-http-port=2113 --ext-http-port=2114 --cluster-size=3 --discover-via-dns=false --gossip-seed=192.168.0.2:2113,192.168.0.3:2113
EventStore.ClusterNode.exe --mem-db --log c:\dbs\cluster\log2 --int-ip 192.168.0.2 --ext-ip 192.168.0.2 --int-tcp-port=1111 --ext-tcp-port=1112 --int-http-port=2113 --ext-http-port=2114 --cluster-size=3 --discover-via-dns=false --gossip-seed=192.168.0.1:2113,192.168.0.3:2113
EventStore.ClusterNode.exe --mem-db --log c:\dbs\cluster\log3 --int-ip 192.168.0.3 --ext-ip 192.168.0.3 --int-tcp-port=1111 --ext-tcp-port=1112 --int-http-port=2113 --ext-http-port=2114 --cluster-size=3 --discover-via-dns=false --gossip-seed=192.168.0.1:2113,192.168.0.2:2113
```

## Using DNS

Entering the commands above into each node is tedious and error-prone (especially as the replica set counts go up). Another configuration option is to create a DNS entry that points to all the nodes in the cluster and then specifying that DNS entry on the command line along with the appropriate port

```powershell
EventStore.ClusterNode.exe --log c:\dbs\cluster\log1 --int-ip 192.168.0.1 --ext-ip 192.168.0.1 --int-tcp-port=1111 --ext-tcp-port=1112 --int-http-port=2113 --ext-http-port=2114 --cluster-size=3 --cluster-dns mydomain.com --cluster-gossip-port=2113
EventStore.ClusterNode.exe --mem-db --log c:\dbs\cluster\log2 --int-ip 192.168.0.2 --ext-ip 192.168.0.2 --int-tcp-port=1111 --ext-tcp-port=1112 --int-http-port=2113 --ext-http-port=2114 --cluster-size=3 --cluster-dns mydomain.com --cluster-gossip-port=2113
EventStore.ClusterNode.exe --mem-db --log c:\dbs\cluster\log3 --int-ip 192.168.0.3 --ext-ip 192.168.0.3 --int-tcp-port=1111 --ext-tcp-port=1112 --int-http-port=2113 --ext-http-port=2114 --cluster-size=3 --cluster-dns mydomain.com --cluster-gossip-port=2113
```

<span class="note--warning">This method is also good for HTTP clients as you can avoid using a load balancer and fall back to round robin DNS for many deployments.</span>

## Internal vs. External

All communications in Event Store are optionally segregated to different networks. Internal networks for tasks like replication and external for talking to clients. You can place these communications on segregated networks if you wish and it is often a good idea to do so both for performance and security purposes.

To setup an internal network all the command line parameters provided above have `int-` options. All communications channels also support the enabling of SSL for the connections.

<!-- TODO: How? Is this the same as below? -->

## HTTP Clients

If you want to use the HTTP API, then you would add a load balancer in front of the three nodes. It does not matter which node receives a request as the requests the node will forward the request internally. With this setup, you can lose any one machine with an easy setup. <!-- TODO: What does this mean? -->

## Native TCP Clients

You can also connect to the cluster using the native TCP interface. The client APIs support switching between nodes internally. As such if you have a master failover the connection will automatically failover and handle retries to another node.

To set up a connection as above, in the command line you provide gossip seeds to the connection. The client will use the gossip seeds to begin gossiping information about the cluster.

```csharp
EventStoreConnection.Create(
        ConnectionSettings.Create().KeepReconnecting(),
        ClusterSettings.Create()
        .WithGossipTimeoutOf(TimeSpan.FromMilliseconds(500))
        .WithGossipSeeds(new []
{
        new IPEndPoint(IPAddress.Parse("192.168.0.1"), 2113),
        new IPEndPoint(IPAddress.Parse("192.168.0.2"), 2113),
        new IPEndPoint(IPAddress.Parse("192.168.0.3"), 2113)
}));
```

As in the example above, you can also use DNS to avoid manually specifying the seeds. You add the nodes to a DNS record and then specify that DNS entry to the connection to locate nodes.

```csharp
EventStoreConnection.Create(ConnectionSettings.Create()
                            .KeepReconnecting(),
                            ClusterSettings.Create()
                            .SetClusterDns("mycluster.com"))
.SetGossipPort(2113)
```

_For those using the closed source version `GossipPort` is an alias for `ManagerPort` as the closed source version includes a node manager on each physical node. This allows for controlling many virtual nodes on a machine with easy configuration. The manager also acts as a supervisor for the nodes_

As mentioned the connection will automatically reconnect during node failures. You can control this behaviour with options on the `ConnectionSettings` such as limiting retry attempts or frequency. The connection and durable subscription will even manage a subscription during node failures, you will not even receive duplicated messages over your durable subscription.
