#!/bin/bash

usage="$(basename "$0") [-h] [-v num]
options:
    -h  show this help text
    -v  MESA version number. 10000 (default) or 9793."

OPTIND=1         # Reset in case getopts has been used previously in the shell.
# Initialize variables:
version=10000
while getopts "hv:" opt; do
    case "$opt" in
	h)  echo "$usage"
	    exit
	    ;;
	v)  version=$OPTARG
	    ;;
    esac
done
shift $((OPTIND-1)) # In case I add other stuff later...

#Set to the best tag for that version number.
case "$version" in
    9793)   tag=9793.03
	    ;;
    10000)  tag=10000.01
	    ;;
esac

#echo $tag


docker run -it --rm \
       -e DISPLAY \
       -v $PWD/docker_work:/home/docker/docker_work \
       -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
       evbauer/mesa_lean:"$tag"
