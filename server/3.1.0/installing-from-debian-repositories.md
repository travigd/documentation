---
title: "Installing on Ubuntu via the Debian Repository"
section: "Server"
version: "3.1.0"
pinned: true
---

If deploying on Ubuntu 14.04, or another Debian-derived version of Linux with the same version of `libc`, you can install Event Store via our package repository. When installing you can either install the latest version, or add a snapshot repository which pins a specific version.

We recommend pinning a specific version in production.

To install, the following steps must be followed:

- Add the Event Store GPG signing key using `apt-key`
- Add the package repository to the list of system sources
- Update the package cache
- Install the package

## Installation Script

<span class="note--warning">
Please note that all packages we distribute are targeted at the amd64 architecture. Failing to include the `[arch=amd64]` clause in the repository specification will cause `apt-get` to fail during update.
</span>

The following script will perform these actions, installing the latest version each time:

```bash
curl https://apt-oss.geteventstore.com/eventstore.key | sudo apt-key add -
echo "deb [arch=amd64] https://apt-oss.geteventstore.com/ubuntu/ trusty main" | sudo tee /etc/apt/sources.list.d/eventstore.list
sudo apt-get update
sudo apt-get install eventstore-oss
```

To add a snapshot in order to pin the installed release to a specific version, modify the entry in `eventstore.list` to use the version number rather than a `main` component, for example:

```
deb [arch=amd64] https://apt-oss.geteventstore.com/ubuntu/ trusty v3.1.0
```

## Configuration

When the Event Store package is installed, the service is not started by default. This is to enable you to modify the configuration, located at `/etc/eventstore/eventstore.conf` according to your requirements. This is to prevent a default database being created.

## Starting and stopping the Event Store service

The Event Store packages come complete with upstart scripts which supervise instances. Upon package installation they are not started by default. To start the Event Store service after modifying the configuration to suit your requirements, use this command:

```bash
sudo service eventstore start
```

To stop the Event Store service, use this command:

```bash
sudo service eventstore stop
```
