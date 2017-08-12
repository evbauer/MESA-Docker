#!/bin/bash

export DISPLAY=localhost:0.0

# Needs a windows style path to mount.
export HERE=$(echo $PWD | sed -e 's/^\///' -e 's/\//\\/g' -e 's/^./\0:/')

# docker-machine mount folder
/c/Program\ Files/Oracle/VirtualBox/VBoxManage.exe \
    sharedfolder add mesa-machine \
    --name mesa_mount \
    --hostpath $HERE/docker_work \
    --automount

#Check to see if mesa-machine exists
MACHINE_EXISTS=$(docker-machine ls | grep mesa-machine -c)
#If not create machine, otherwise start it
if [ $MACHINE_EXISTS -eq 0 ]
then
    # Creating a machine with 2GB of RAM and 2 CPUs
    docker-machine create \
		   -d virtualbox \
		   --virtualbox-memory=2048 \
		   --virtualbox-cpu-count=2 \
		   --virtualbox-disk-size=10000 \
		   mesa-machine
    
    echo "MESA MACHINE CREATED"
else
    docker-machine start mesa-machine
    echo "MESA MACHINE STARTED"
fi

#Connect terminal to the docker machine to allow running docker commands.
eval "$(docker-machine env mesa-machine)"

START_DOCKER='docker run -d --rm
--name mesa_dock
-p 6158:22
-v /mesa_mount:/home/docker/docker_work
evbauer/mesa_lean:9793.01
sleep infinity'
START_SSH='docker exec --user root mesa_dock service ssh start'

docker-machine ssh mesa-machine $START_DOCKER
docker-machine ssh mesa-machine $START_SSH

ip=$(docker-machine ip mesa-machine)
# Bind port of docker container inside the machine to local port 20000
ssh -Nf -L20000:localhost:6158 docker@$ip
# ssh with X11 forwarding for pgstar.
ssh -Y -p 20000 docker@localhost

docker kill mesa_dock
docker-machine stop mesa-machine
