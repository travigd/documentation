---
outputFileName: index.html
---

# Reliability

You should look at reliability from a holistic perspective. Even though Event Store treats data transactionally with full durability assurances this will not help you if the hardware on your machine does not support it.

Many consumer grade disks (and SSDs especially) lie about durability to appear faster. This is fine until you have a power outage and lose information. By default on a client installation Windows enables disk caching. <!-- TODO: Why is this relevant? RAM out of control, I think was also mentioned elsewhere? -->

These issues do not just affect Event Store. Other vendors and projects have created tests to check whether you may be losing data. We recommend running one of [these such tests](http://archive.li/WTeAE) against your production environment.

You can look at the state of your drives on Linux by using the following command:

```bash
sudo hdparm -I {drive}
```

For example, check _/dev/sda_ to see if caching is enabled on your drive. Be wary though, just because caching is disabled does not mean that all writes will be fully durable. If you are running Linux you might want to consider adding the following to _/etc/hdparm.conf_:

```shell
/dev/yourdrive {
      write_cache = off
}
```

If you are running the clustered version of Event Store you may wish to allow these unlikely events to happen. The drives will run faster with caching enabled and it is unlikely that would lose three machines at the same time with corruption (providing you don’t plug them all into the same power outlet). If this were to happen you can truncate your data and re-replicate from the other nodes.
