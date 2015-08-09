---
title: "Default Directories"
section: "Server"
version: "3.1.0 (pre-release)"
pinned: true
---

The "Application Directory" herein referes to the directory "EventStore.ClusterNode.exe" or "eventstored" is located in.

### Linux ###
- **Content :** /usr/share/eventstore
- **Configuration :** /etc/eventstore/
- **Data :** /var/lib/eventstore
- **Logs :** /var/log/eventstore
- **Test Client :** ApplicationDirectory/testclientlogs
- **Web Content :** DefaultContentDirectory/clusternode-web (if ApplicationDirectory/clusternode-web doesn't exist)
- **Projections :** DefaultContentDirectory/projections (if ApplicationDirectory/projections doesn't exist)
- **Prelude :** DefaultContentDirectory/Prelude (if ApplicationDirectory/Prelude doesn't exist)

### All other OSes (Includes Windows/OSX) ###
- **Content :** ApplicationDirectory
- **Configuration :** ApplicationDirectory
- **Data :** ApplicationDirectory/data
- **Logs :** ApplicationDirectory/logs
- **Test Client Log :** ApplicationDirectory/testclientlogs
- **Web Content :** DefaultContentDirectory/clusternode-web (if ApplicationDirectory/clusternode-web doesn't exist)
- **Projections :** DefaultContentDirectory/projections (if ApplicationDirectory/projections doesn't exist)
- **Prelude :** DefaultContentDirectory/Prelude (if ApplicationDirectory/Prelude doesn't exist)