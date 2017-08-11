#!/bin/bash

docker run -d --rm \
       --name mesa_dock \
       -p 6158:22 \
       evbauer/mesa_lean:9793.01 \
       sleep infinity

#figure out the voume mounting later
#-v $HERE/docker_work:/home/docker/docker_work \

docker exec --user root mesa_dock service ssh start
