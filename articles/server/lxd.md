## Setting up lxd

`lxd` is a tool for managing `lxc` containers. It is installed by default on ubuntu server 20.04. At first launch run `lxd init` defaults should be fine for now.

Create a container `lxc launch ubuntu:18.04 $NAME` this will create and start a new ubuntu 18.04 container. You can confirm with `lxc list`

Can execute commands in the lxc container with

`lxc exec $NAME -- <commands>`

For example you can get an interactive shell in the container with `lxc exec $NAME -- /bin/bash`

You can move files to and from the container with `file push/pull`

e.g.

`lxc file push <src> $NAME/<dst>`

`lxc file pull $NAME/<dst> <src>`

To stop a container simply

`lxc stop $NAME`

To remove a container

`lxc delete $NAME`

## Getting new lxc images

LXD comes with 3 default remotes providing images:

    1. ubuntu: (for stable Ubuntu images)
    2. ubuntu-daily: (for daily Ubuntu images)
    3. images: ([for a bunch of other distros](https://us.images.linuxcontainers.org/))

To start a container from them, simply do:
```
lxc launch ubuntu:16.04 my-ubuntu
lxc launch ubuntu-daily:18.04 my-ubuntu-dev
lxc launch images:centos/6/amd64 my-centos
```

## Setup shared directory

lxd `disk` device can be used to map a folder in the container to a folder on the host. e.g.

`lxc config device add $NAME $DEVNAME disk source=/opt path=opt`

## Forwarding host ports to lxc container

lxd provides the `proxy` device, that allows you to map a host port to the container port. This can be used to forward requests to a reverse proxy running in a container.

```
$ lxc config device add $NAME $DEVICENAME proxy listen=tcp:0.0.0.0:$HOSTPORT connect=tcp:127.0.0.1:$SERVPORT
```

The command that creates the proxy device is made of the following components.

* `lxc config device add` adds a new device.
* `proxy` adding a LXD Proxy Device.
* `listen=tcp:0.0.0.0:80` listen (on the host by default) on all network interfaces on TCP port 80.
* `connect=tcp:127.0.0.1:80` connect (to the container by default) to the existing TCP port 80 on localhost.

Be sure to add proxy protocol to the webserver config. e.g. for nginx

```
server {
    listen 80 proxy_protocol;

    ...

}
```

Now requests comming in to the host on port 80 will be forwarded with the proxy protocol to the containers port 80.