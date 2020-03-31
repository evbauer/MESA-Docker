#!/bin/bash

usage="$(basename "$0") [-h] [-v num]
options:
    -h  show this help text
    -v  MESA version number. 12778 (default), 12115, 11701, 11554, 11532, 10398, 10108, 10000, or 9793."

OPTIND=1         # Reset in case getopts has been used previously in the shell.
# Initialize variables:
version=12778
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
    10398)  tag=10398.04
	    ;;
    11532)  tag=11532.01
	    ;;
    11554)  tag=11554.02
	    ;;
    11701)  tag=11701.01
	    ;;
    12115)  tag=12115.01
	    ;;
    12778)  tag=12778.01
	    ;;
esac

#echo $tag
tmp=$(command -v docker)
if [[ $? != 0 ]];then
    echo "Warning docker not found"
    echo 'Check docker folder is in $PATH'
    exit 1
fi

docker run -d --rm \
       --name mesa_dock \
       -p 6158:22 \
       -v "$PWD/docker_work":/home/docker/docker_work \
       evbauer/mesa_lean:"$tag" \
       sleep infinity

docker exec --user root mesa_dock service ssh start

echo "password is mesa"
ssh -Y -p 6158 docker@localhost

docker kill mesa_dock

