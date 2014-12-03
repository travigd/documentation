---
title: "Database Backup"
section: "Server"
version: 3.0.1
---

Backing up an Event Store database is straightforward, however relies on having the steps carried out in the correct order as detailed below. *Many people do not rely on hot backups in a highly available cluster but instead increase their node counts to retain further copies of data.*

## Backing up a database

1. Copy `*.chk` to the backup location.
1. Copy all remaining files and directories to the backup location.

## Restoring a database

1. Copy `chaser.chk`, 
1. Rename the _copy_ to `truncate.chk`
1. Copy all files to the desired location.

## Differential backup

Most data is stored in *chunk files*, named `chunkX.Y`, where X is the chunk number, and Y is the version of that chunk file. As the Event Store scavenges, it creates new versions of scavenged chunks which are interchangeable with older versions (but for the removed data). 

*Consequently, it is only necessary to keep the file whose name has the highest `Y` for each `X`, as well as the checkpoint files and the index directory (to avoid expensive index rebuilding).*

## Other Options

There are many other options available for how to back up an Event Store database. As an example it is relatively simple to setup a durable subscription that then also writes all of the events to some other storage mechanism such as a key/value store or a column store. These methods would however require a manual setup for restoring back to a cluster group. This method also allows for a near real-time back up to some other storage mechanism.

This option can be expanded upon to use a second Event Store node/cluster as a back up. This is commonly known as a primary/secondary back up scheme. The primary cluster runs and asynchronously pushes data to a second cluster as described above. The second cluster/node is available in the case of disaster for the first primary cluster. People using this strategy generally only support a manual failover from Primary to Secondary as automated strategies risk ending up in a split brain problem between the two.