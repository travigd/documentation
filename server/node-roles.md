---
outputFileName: index.html
---

# Cluster Node Roles

Every node in an Event Store cluster can have one of three roles.

## Master

A cluster assigns the `Master` role based on an election process. The node with the `Master` role ensures that the data are committed and persisted to disk before sending back to the client an acknowledge message. A cluster can only have one Master at a time. If a cluster detects two nodes with a Master role, a new election begins and shuts down the node with less data to restart and re-join the cluster.

## Slave

A cluster assigns the `Slave` role based on an election process. A cluster uses one or more nodes with the `Slave` role to form the quorum, or the majority of nodes necessary to confirm that a write is persisted.

## Clone

If you add nodes to a cluster beyond the number of nodes specified in the `ClusterSize` setting the cluster automatically assigns them the `Clone` role.

A cluster asynchronously replicates data one way to a node with the `Clone` role. You don't need to wait for an acknowledgement message as the node is not part of the quorum. For this reason a node with a `Clone` role does not add much overhead to the other nodes.