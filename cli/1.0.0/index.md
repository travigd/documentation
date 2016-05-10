---
title: "Event Store CLI"
section: "CLI"
version: 1.0.0
pinned: true
---

The Event Store CLI utilizes the HTTP API of Event Store to make it easier for the user to perform operations on an Event Store Node.

The [Event Store CLI](https://geteventstore.com/downloads) is distributed as a command line executable. There are separate distributions for Windows, Linux and OSX.

## Introduction to the Event Store CLI

### Configuration

The Event Store CLI's configuration can be manipulated in 2 ways.

The first is by means of a configuration file that is stored in the following location depending on the operating system.

#### Windows
```
%AppData%/eventstore.rc
```

#### Linux/OSX
```
~/.eventstorerc
```

The contents of the configuration should contain any of the following values

```
serverurl="http://127.0.0.1:2113"
username="admin"
password="changeit"
output="json"
verbose=true
```

The other method of specifying the configuration is to pass them in when performing a command.

```
./es-cli --username=ouro --password=ouropass admin shutdown
```

### Usage
#### Basic Usage

```
./es-cli [options] <command> [args]
```
Example for shutting down a node, the shutdown command lives under the admin section.

```
./es-cli --serverurl="http://localhost:2113" admin shutdown
```

#### Getting Help
Each of the functions in the CLI attemps to provide as much information as possible to help the user provide the necessary information to succesfully issue a command.

```
./es-cli --help
usage: Event Store CLI [<options>] <command> [<args>]

Available options are:
--version	Get the version of Event Store CLI
--help		Display help
--output	How output should be formatted (text | json)
--password	The admin password
--serverurl	The url of the Event Store server
--username	The admin username
--verbose	Verbose output of requests sent to the Event Store node

Available commands are:
projections	projections (delete, disable, enable, list, new, result, state, status)
competing	competing (list, create, update)
admin		admin (scavenge, shutdown)
user		user (add, change_password, delete, disable, update, enable, list, reset_password)
```

Getting the available commands underneath the admin section.

```
/es-cli admin --help
usage: Event Store CLI admin [--version] [--help] <command> [<args>]

Available commands are:
    scavenge    Schedule a scavenge on Event Store
    shutdown    Shutdown the Event Store instance
```

Getting the required parameters for adding a new user.

```
./es-cli user --help add
Usage: add [options]
	Add a user
Options:
  -loginname                 Login Name
  -password                  Password
  -fullname                  Full Name
  -isadmin                   Is Administrator
  -isoperations              Is Operations
```

### Troubleshooting
The Event Store CLI uses the HTTP API and therefore we can print out the requests/responses from the calls to give the user a better debugging/troubleshooting experience. This is accomplished by setting the verbose configuration value to true.

### Having Issues
The repository is currently closed source (but not for long). If you encounter any issues, please don't hesitate to open an issue on the [Event Store github repository](https://github.com/EventStore/EventStore) with the **[CLI]** tag for now.
