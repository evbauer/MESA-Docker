#!/bin/bash

docker run -it --rm \
       -e DISPLAY=localhost:0 \
       -v $PWD/docker_work:/home/docker/docker_work \
       evbauer/mesa_lean:9793.01
