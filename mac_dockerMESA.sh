#!/bin/bash

xhost
ip=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
#echo $ip
xhost + $ip

docker run -it --rm \
       -e DISPLAY=$ip:0 \
       -e OMP_NUM_THREADS=$(getconf _NPROCESSORS_ONLN) \ # Right now the container's .bashrc overrides this.
       -v $PWD/docker_work:/home/docker/docker_work \
       evbauer/mesa9793_installed:0.2
