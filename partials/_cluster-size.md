> [!TIP]
> When setting up a cluster, you generally want an odd number of nodes as Event Store uses a quorum based algorithm to handle high availability. We recommended you define an odd number of nodes to avoid split brain problems.
>
> Common values for the ‘ClusterSize’ setting are 3 or 5 (to have a majority of 2 nodes and a majority of 3 nodes).

> [!NEXT]
> [Read here](~/server/node-roles.md) for more information on the roles available for nodes in an Event Store cluster.