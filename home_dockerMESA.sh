#!/bin/bash

export DISPLAY=localhost:0.0

# Creating a machine with 2GB of RAM and 2 CPUs

docker-machine create \
	       -d virtualbox \
	       --virtualbox-memory=2048 \
	       --virtualbox-cpu-count=2 \
	       --virtualbox-disk-size=10000 \
	       mesa-machine

echo "MESA MACHINE CREATED"

# Needs a windows style path to mount.
#export HERE=$(echo $PWD | sed -e 's/^\///' -e 's/\//\\/g' -e 's/^./\0:/')
#figure out the voume mounting later
#-v $HERE/docker_work:/home/docker/docker_work \

#Connect terminal to the docker machine to allow running docker commands.
eval "$(docker-machine env mesa-machine)"

docker run -d --rm \
       --name mesa_dock \
       -p 6158:22 \
       evbauer/mesa_lean:9793.01 \
       sleep infinity

docker exec --user root mesa_dock service ssh start

ip=$(docker-machine ip mesa-machine)
# Bind port of docker container inside the machine to local port 20000
ssh -Nf -L20000:localhost:6158 docker@$ip
# ssh with X11 forwarding for pgstar.
ssh -Y -p 20000 docker@localhost

#Do something here to cleanly close down the VM.
