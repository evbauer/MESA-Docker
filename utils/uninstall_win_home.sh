#!/bin/bash

OPTIND=1         # Reset in case getopts has been used previously in the shell.

# default drive letter:
install_drive=C

while getopts "d:" opt; do
    case "$opt" in
	d)  install_drive=$OPTARG
	    ;;
    esac
done
shift $((OPTIND-1)) # In case I add other stuff later...

export MACHINE_STORAGE_PATH=${install_drive}:\\docker
echo $MACHINE_STORAGE_PATH

docker-machine ls
docker-machine rm mesa-machine
