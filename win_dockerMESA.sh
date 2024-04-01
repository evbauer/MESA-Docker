#!/bin/bash

# Check to see we are on windows home
if [[ ! -f "/c/Windows/System32/BitLockerWizard.exe" ]];then
	echo "Warning you are running Windows Home instead of Windows Pro"
	echo "Please follow the instructions for Windows Home"
	exit 1
fi

# Check if virtulization has been enabled
if [[ ! $(systeminfo | grep -q "Virtualization Enabled In Firmware: Yes") -eq 0 ]];then 
    echo "Warning virtualization is not enabled"
    echo "Please reboot your system and change the settings in your BIOS"
    exit 1
fi


usage="$(basename "$0") [-h] [-v num]
options:
    -h  show this help text
    -v  MESA version number. r24.03.1 (default), r23.05.1, r22.11.1, r22.05.1, r21.12.1, 15140, 12778, 12115, 11701, 11554, 11532, 10398, 10108, 10000, or 9793."

OPTIND=1         # Reset in case getopts has been used previously in the shell.
# Initialize variables:
version=r24.03.1
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
    15140)  tag=15140.01
	    ;;
    r21.12.1)  tag=r21.12.1.01
	       ;;
    r22.05.1)  tag=r22.05.1.01
	       ;;
    r22.11.1)  tag=r22.11.1.01
	       ;;
    r23.05.1)  tag=r23.05.1.01
	       ;;
    r24.03.1)  tag=r24.03.1.01
	       ;;
esac

#echo $tag
tmp=$(command -v docker)
if [[ $? != 0 ]];then
    echo "Warning docker not found"
    echo 'Check docker folder is in $PATH'
    exit 1
fi


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
