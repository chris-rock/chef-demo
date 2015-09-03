# Chef Demo Infrastructure

This project illustrates a setup of the Chef ecosystem. Currently,
it includes the following products:

- Chef Server (including Chef Manage) running in a VM
- Chef Analytics running in separate VM
- Chef Clients running in Docker container

## Preconditions

- [VirtualBox] (https://www.virtualbox.org/wiki/Downloads)
- [Vagrant] (https://www.vagrantup.com/downloads.html)
- [Docker] (https://docs.docker.com/installation/)

## Get started

At first, we have to start the servers. Please ensure the order during the
first boot up. The Chef Server needs to be started before Analytics.

```bash
vagrant up server
vagrant up analytics
```

Verify that [Chef Server](https://192.168.34.10/login) is running properly.
Visit the Web UI via:

```code
url:      https://192.168.34.10/login
username: admin
password: insecurepassword
```

Now, verify the [Chef Analytics UI](https://192.168.34.11) is available at https://192.168.34.11. Use the same credentials as for the Chef Server. Finally, you should see the Chef Analytics Timeline dashboard.

Before we run the client, we need to build the `chef-client` docker image:

```bash
docker build -t chef-client ./client
```

To run all commands that we mentioned above together:

```bash
./run prepare
```

## Start clients

The `run` command allows you to start multiple chef-clients quickly. It will start docker container with Chef clients. Those clients will automatically register at our Chef Server.

```bash
./run
    [prepare]
    Boots VMs and prepares the Docker image

    [start] [<number>]
    Starts a given number of containers with chef-client.
    The client automatically registers at the chef server.

    [stop]
    Stops all running chef-clients.
```

Now we are read to kick off some clients:

```bash
./run start 10
```

Now, you can see the 10 clients registered in Chef Server and events have been triggered to Chef Analytics.

## Troubleshoot

If you use Mac, boot2docker is required. We may move the dependency in a VM later on. Currently, you need to install [boot2docker](https://github.com/boot2docker/osx-installer/releases) or [Docker Toolbox](https://www.docker.com/toolbox)

For boot2docker run:

```bash
boot2docker init
boot2docker up
eval "$(boot2docker shellinit)"
```

## Authors

- Author: Christoph Hartmann <chartmann@chef.io>
