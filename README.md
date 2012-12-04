node-monitor
======

Simple machine monitoring.

## Assumptions

## Prerequisites
	
* Amazon EC2 account

## Installation

There are various ways to use the monitor.

### NPM

1. Clone the repository.

```
git clone ...
```

1. Install the dependencies through the Node.js Package Manager, which will add `node-monitor` to your PATH.

```
cd node-monitor
sudo npm install -g`
```

## Configuration (Local)

You're going to need your `Amazon EC2 credentials` on hand. `IAM` credentials are highly recommended.

### Mandatory

1. To configure the monitor's credentials:

```
node-monitor set credentials --key (-k) <key> --secret (-s) <secret>
```

### Optional

1. To configure the monitor's AWS CloudWatch Namespace:

```
node-monitor set namespace --name (-n) <namespace>
```

**The default is node-monitor**

1. To configure the monitor's interval, in minutes:

```
node-monitor set interval --interval (-i) <interval>
```

**The default is 5**

## Usage

1. Run the monitor with default configuration.

```
node-monitor
```

1. Run the monitor, on Ubuntu, as an Upstart job:

```
node-monitor upstart
```

## Structure

The project is written in CoffeeScript, and compiled to JavaScript. The script to do this is in the `ci` folder.

```
- coffee
- js
- ci
```

## Base Dependencies

## Machine Dependencies & Setup

## Plugins

Plugins consist of code blocks which run as _two_ different forms: in _intervals_ or _continuously_. To keep it simple, they exist as single file, unique identities - configuration and all - in the `plugins` directory. They are comprised of:

1. A name
1. Configuration logic
1. Logic
1. Hook implementations

If you wish to contribute a plugin, submit a pull request and update this README in accordance.

### api

### cpu

### df

### filesize

### free

### lsof

### services

### tail

Tail files.

### filechange

Watch for changes in files.

### uptime

### who

## Hooks

While Plugins are self-contained, node-monitor provides interfaces for them to store metrics in a database, push to a socket, write to a file, or send to CloudWatch.

### cloudwatch

### redis

### cassandra

### solr

### websocket

### log

### mqtt

## Alerts

node-monitor also provides an an alert interface for sending SMS, e-mail, or webservice requests when configured thresholds are breached.

## Configuration (Remote)
