#!/bin/bash

docker run -it --rm \
       -e DISPLAY \
       -v $PWD/docker_work:/home/docker/docker_work \
       -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
       evbauer/mesa_lean:9793.01
