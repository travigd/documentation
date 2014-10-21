---
layout: docs
title: "Deploy with Puppet"
---

**Currently v2**

To get started you need a RPM package of event store. You can make an [EventStore RPM](https://github.com/haf/fpm-recipes/tree/master/eventstore) on CentOS.

Once you have your package, you need to have a puppet module for automating the deployment. [There's puppet-eventstore](https://github.com/haf/puppet-eventstore) to do that. It will ensure the package you just created is installed and allow you to give parameters to Event Store.

The module has a dependency on [puppet-supervisor](https://github.com/haf/puppet-supervisor) which is used to run the server, which in turn requires the package [python-supervisor](https://github.com/haf/fpm-recipes/tree/master/python-supervisor). The RPM has a dependency on a [mono](https://github.com/haf/fpm-recipes/tree/master/mono) package.