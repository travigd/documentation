---
title: "Default Directories"
section: "Server"
version: "4.0.2"
pinned: true
---

The default directories used by Event Store vary by platform to best fit with the expectations of users in each case.

<span class="note--warning">
Paths beginning with "." are relative to the directory in which _eventstored_ or _EventStore.ClusterNode.exe_ are located. Absolute paths are as written.


### Linux

-   **Application:** _/usr/bin_ (when installed via Debian package)
-   **Content:** _/usr/share/eventstore_
-   **Configuration:** _/etc/eventstore/_
-   **Data:** _/var/lib/eventstore_
-   **Application Logs:** _/var/log/eventstore_
-   **Test Client Logs:** _./testclientlog_ (not included in Debian package)
-   **Web Content:** _./clusternode-web_ _then_ _{Content}/clusternode-web_
-   **Projections:** _./projections_ _then_ _{Content}/projections_
-   **Prelude:** _./Prelude_ _then_ _{Content}/Prelude_

### All other OSes (Includes Windows/macOS)

-   **Content:** _./_
-   **Configuration:** _./_
-   **Data:** _./data_
-   **Application Logs:** _./logs_
-   **Test Client Log:** _./testclientlogs_
-   **Web Content:** _./clusternode-web_ _then_ _{Content}/clusternode-web_
-   **Projections:** _./projections_ _then_ _{Content}/projections_
-   **Prelude:** _./Prelude_ _then_ _{Content}/Prelude_
