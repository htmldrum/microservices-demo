# Nomad Example

### Table Of Content
1. [Requirements](#requirements)
2. [Getting started](#getting-started)

### Requirements
  * [Ansible](https://ansible.com) `~> 2.1.0.0`
  * [GNU Make](https://www.gnu.org/software/make/) `~> 4.1`
  * [Vagrant](https://vagrantup.com) `~> 1.8.1`
  * [VirtualBox](https://www.virtualbox.org/) `~> 5.0.22`

### Getting Started
_This example sets up a Nomad cluster with one server and three nodes. Make sure you have at least 6272MB of RAM available._

The easiest way to get started is to simply run
```
$ make
```

This will:

  * Bring up the Vagrant boxes
  * Install all the dependencies
  * Setup the Nomad cluster
  * Deploy the demo application

**Disclaimer**: _If this is the first time that you are running this, it may take a while pulling all the Vagrant images, installing
                 packages and what not, so please be patient. The output is quite verbose, so at all points you shoulld know what is
                 going on and what went wrong if anything fails._

### Locating The Endpoint
Once the `make` run is done, the application should be up for scheduling. Login into the **nomad-server** box to find out what is the
current state of things:
```
$ vagrant ssh nomad-server
```

Then ask Nomad about the status of the **weavedemo** job:
```
$ nomad status weavedemo
ID          = weavedemo
Name        = weavedemo
Type        = service
Priority    = 50
Datacenters = dc1
Status      = running
Periodic    = false

Allocations
ID        Eval ID   Node ID   Task Group  Desired  Status
0f64a518  c318487e  b61a8cc5  catalogue   run      running
455d1a37  c318487e  bc8fc362  payment     run      running
584f96f8  c318487e  c1499b10  rabbitmq    run      running
6986b41f  c318487e  b61a8cc5  accounts    run      running
71578e7b  c318487e  c1499b10  shipping    run      running
b0e3c350  c318487e  b61a8cc5  login       run      running
d07fd50c  c318487e  c1499b10  frontend    run      running
d180deb8  c318487e  bc8fc362  orders      run      running
eeaf3a99  c318487e  bc8fc362  cart        run      running
```

Now let's take the Allocation ID of the **frontend** task group and ask Nomad about its status:
```
$ nomad alloc-status d07fd50c
ID            = d07fd50c
Eval ID       = c318487e
Name          = weavedemo.frontend[0]
Node ID       = c1499b10
Job ID        = weavedemo
Client Status = running

Task "edgerouter" is "running"
Task Resources
CPU    Memory          Disk     IOPS  Addresses
0/100  9.8 MiB/32 MiB  300 MiB  0     http: 192.168.59.103:80
                                      https: 192.168.59.103:443

Recent Events:
Time                    Type        Description
07/01/16 18:06:03 CEST  Started     Task started by client
07/01/16 18:05:25 CEST  Restarting  Task restarting in 26.343413077s
07/01/16 18:05:25 CEST  Terminated  Exit Code: 1, Exit Message: "Docker container exited with non-zero exit code: 1"
07/01/16 18:05:24 CEST  Started     Task started by client
07/01/16 18:04:37 CEST  Restarting  Task restarting in 26.58623629s
07/01/16 18:04:37 CEST  Terminated  Exit Code: 1, Exit Message: "Docker container exited with non-zero exit code: 1"
07/01/16 18:04:36 CEST  Started     Task started by client
07/01/16 18:02:54 CEST  Received    Task received by client

Task "front-end" is "running"
Task Resources
CPU    Memory          Disk     IOPS  Addresses
0/100  61 MiB/128 MiB  300 MiB  0

Recent Events:
Time                    Type      Description
07/01/16 18:05:54 CEST  Started   Task started by client
07/01/16 18:02:54 CEST  Received  Task received by client
```

If you look carefully, you will notice that the **edgerouter** task is **running** and among the resources that have been
allocated for it, ports 80 (HTTTP) and 443 (HTTPS) have been bound to the ip **192.168.59.103**. This is the IP that you
can use on your browser to access the application.
