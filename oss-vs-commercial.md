# OSS Vs Commercial editions

Event Store ships in two editions and this guide outlines the differences between the two.

## Open Source

### Support

Our community provides support through an active [Google group](https://groups.google.com/forum/#!forum/event-store) and [GitHub issue queue](https://github.com/eventstore/eventstore/issues).

## Commercial

### Support

We offer [commercial and Enterprise](https://eventstore.org/support/) level support plans tailored to suit your needs.

### Manager nodes in high availability mode

High availability Event Store allows you to run more than one node as a cluster. With the open source edition, you can only create clusters consisting of database nodes. With the commercial edition the cluster can also contain manager nodes that help with determining state and supervise database nodes.

### Database and backup checks

The DbVerifier tool lets you verify that your database backups are complete and valid.

### Events Correlation Visualizer

This plugin for to the Event Store web admin UI provides a visual overview of the relations between Events and Commands using `$correlationId` and `$causationId`.

### GeoReplicas

Replicate Event Store instances, and events stored on them across network and regional partitions.

### Node administration CLI

A command line interface for administering nodes, allowing you to run tasks such as creating user accounts, starting and stopping nodes, and setting configuration.