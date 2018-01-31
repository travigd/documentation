---
section: "Server"
version: "4.0.2"
pinned: true
---

# Installing on Ubuntu via the Debian Repository

> [!WARNING]
> These instructions apply only to users of the Open Source Event Store. Commercial customers have access to a separate package repository which contains all the commercial tools in packaged form.

The Event Store hosts packages on [PackageCloud](https://packagecloud.io/EventStore/EventStore-OSS) and the you can find installation instructions for the supported distributions [here](https://packagecloud.io/EventStore/EventStore-OSS/install).

We recommend pinning a specific version in production.

## Configuration

When you install the Event Store package, the service is not started by default. This is to allow you to change configuration, located at _/etc/eventstore/eventstore.conf_ according to your requirements and to prevent creating a default database.

## Starting and stopping the Event Store service

The Event Store packages come complete with upstart scripts which supervise instances. Upon installation they are not started by default. To start the Event Store service after changing the configuration to suit your requirements, use this command:

```bash
sudo service eventstore start
```

To stop the Event Store service, use this command:

```bash
sudo service eventstore stop
```
