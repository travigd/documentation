# Setting up Varnish in Linux

This document provides a brief guide on how to install Event Store with the varnish reverse proxy in a Linux environment. For more information on how to properly configure varnish for your requirements, read the [Varnish documentation](https://www.varnish-cache.org/trac/wiki/Introduction).

You use a reverse proxy to limit access to Event Store without breaking HTTP caching (authenticate to the proxy not to Event Store itself). Since Event Store runs HTTP only on the loopback adapter, users must enter through the reverse proxy to reach Event Store. [Ben Clark’s Gist](https://gist.github.com/benclark/2695148) contains a more configured varnish configuration that includes basic authentication as well as some other niceties such as adding headers for hits/misses).

The first thing that we will need to do is to install varnish

```bash
sudo curl http://repo.varnish-cache.org/debian/GPG-key.txt | sudo apt-key add -
echo "deb http://repo.varnish-cache.org/ubuntu/ precise varnish-3.0" | sudo tee -a /etc/apt/sources.list
sudo apt-get update
sudo apt-get install varnish
```

Next configure varnish.

```bash
sudo vi /etc/default/varnish
```

Edit the section that looks like:

```bash
DAEMON_OPTS="-a :80 \
             -T localhost:6082 \
             -f /etc/varnish/default.vcl \
             -S /etc/varnish/secret \
             -s malloc,256m"
```

Replace the port with the port you want to run on:

```bash
sudo vi /etc/varnish/default.vcl
```

Set it to:

```bash
backend default {
    .host = "127.0.0.1";
    .port = "2114";
}
```

Finally use `sudo service varnish restart` to restart varnish and Event Store should berunning with a reverse proxy. If you want to check out the status of varnish you can check with `varnishstat` from the command line.
