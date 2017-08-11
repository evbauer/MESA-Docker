#!/bin/bash

export DISPLAY=localhost:0.0

# Creating a machine with 4GB of RAM

docker-machine create \
	       -d virtualbox \
	       --virtualbox-memory=2048 \
	       --virtualbox-cpu-count=2 \
	       --virtualbox-disk-size=10000 \
	       mesa-machine

ip=$(docker-machine ip mesa-machine)

# Get the docker container running inside the machine.
ssh docker@$ip 'bash -s' < start_remote.sh

# Bind port of docker container inside the machine to local port 20000
ssh -Nf -L20000:localhost:6158 docker@$ip
# ssh with X11 forwarding for pgstar.
ssh -Y -p 20000 docker@localhost

#Do something here to cleanly close down the VM.
