---
section: Server
version: 4.0.2
---

# Rebuilding Indexes

As of version 3.9.0 all future indexes will use 64-bit hashes instead of 32-bit hashes. The system will automatically transition from 32-bit to 64-bit by writing all new indexes as 64-bit indexes during the merge process.

If you prefer to use only 64-bit indexes immediately you can force this. For a small database, delete the _index_ <!-- TODO: Which is where?--> folder and let it rebuild (this might take a while)

If you have a large database, remote storage, etc and cannot lose downtime, you can do this operation offline on another node with the following steps:

1.  Take a back up.
2.  Restore the backup to fast local disks.
3.  Delete the _index_ folder from back up.
4.  Run Event Store with a cluster size 3 to prevent other writes. It will rebuild the index.
5.  Restore the index back to a node (_index_ folder).
6.  Let Event Store catch up from master.
7.  Repeat the restore for other nodes.

For other indices, you index will eventually become 64 bit due to the merging process that occurs over time.
