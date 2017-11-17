---
title: "Setting up Projections"
section: "Introduction"
version: "4.0.2"
---

You enable projections with the command line argument `--run-projections=all`. For example:

```powershell
EventStore.ClusterNode.exe --db ./db --log ./logs --run-projections=all
```

You will then see new tabs in the UI:

![image](https://cloud.githubusercontent.com/assets/3100817/11022959/6d9a95ba-866c-11e5-9bfe-92b936411f6d.png)

If you want to use the standard projections, e.g. `fromCategory()` then you can specify the additional argument `--start-standard-projections=true`. For example:

```powershell
EventStore.ClusterNode.exe --db ./db --log ./logs --run-projections=all --start-standard-projections=true
```
