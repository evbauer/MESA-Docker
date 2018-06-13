#!/bin/bash

# Check to see we are on windows home
if [[ $(wmic os get caption) = *"Home"* ]];then
	echo "Warning you are running Windows Home instead of Windows Pro"
	echo "Please follow the instructions for Windows Home"
	exit 1
fi



usage="$(basename "$0") [-h] [-v num]
options:
    -h  show this help text
    -v  MESA version number. 10398 (default), 10108, 10000, or 9793."

OPTIND=1         # Reset in case getopts has been used previously in the shell.
# Initialize variables:
version=10398
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
    10108)  tag=10108.01
	    ;;
    10398)  tag=10398.01
	    ;;
esac

#echo $tag



export DISPLAY=localhost:0.0
# Needs a windows style path to mount.
export HERE=$(echo $PWD | sed -e 's/^\///' -e 's/\//\\/g' -e 's/^./\0:/')

winpty docker run -d --rm \
       --name mesa_dock \
       -p 6158:22 \
       -v "$HERE/docker_work":/home/docker/docker_work \
       evbauer/mesa_lean:"$tag" \
       sleep infinity

winpty docker exec --user root mesa_dock service ssh start

echo "password is mesa"
ssh -Y -p 6158 docker@localhost

docker kill mesa_dock
