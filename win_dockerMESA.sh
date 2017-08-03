#!/bin/bash

export DISPLAY=localhost:0.0
# Needs a windows style path to mount.
export HERE=$(echo $PWD | sed -e 's/^\///' -e 's/\//\\/g' -e 's/^./\0:/')

winpty docker run -d --rm \
       --name mesa_dock \
       -p 6158:22 \
       -v $HERE/docker_work:/home/docker/docker_work \
       evbauer/mesa9793_installed:0.2 \
       sleep infinity

winpty docker exec --user root mesa_dock service ssh start

ssh -X -p 6158 docker@localhost

docker kill mesa_dock
