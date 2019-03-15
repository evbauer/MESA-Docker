#!/bin/bash

# Check to see we are on windows home
if [[ -f "/c/Windows/System32/BitLockerWizard.exe" ]];then
        echo "Warning you are running Windows Pro instead of Windows Home"
        echo "Please follow the instructions for Windows Pro"
        exit 1
fi

# Check if virtulization has been enabled
if [[ ! $(systeminfo | grep -q "Virtualization Enabled In Firmware: Yes") -eq 0 ]];then 
    echo "Warning virtualization is not enabled"
    echo "Please reboot your system and change the settings in your BIOS"
    exit 1
fi



usage="$(basename "$0") [-h] [-v num] [-d let]
options:
    -h  show this help text
    -v  MESA version number. 11554 (default), 11532, 10398, 10108, 10000, or 9793.
    -d  letter for drive to install on. Default is C."

OPTIND=1         # Reset in case getopts has been used previously in the shell.
# Initialize variables:
version=11554
# default drive letter:
install_drive=C

while getopts "hv:d:" opt; do
    case "$opt" in
	h)  echo "$usage"
	    exit
	    ;;
	v)  version=$OPTARG
	    ;;
	d)  install_drive=$OPTARG
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
    11554)  tag=11554.01
	    ;;
esac

#echo $tag

tmp=$(command -v docker-machine)
if [[ $? != 0 ]];then
    echo "Warning docker-machine not found"
    echo 'Check docker-machine folder is in $PATH'
    exit 1
fi

tmp=$(command -v docker)
if [[ $? != 0 ]];then
    echo "Warning docker not found"
    echo 'Check docker folder is in $PATH'
    exit 1
fi


export DISPLAY=localhost:0.0
export MACHINE_STORAGE_PATH=${install_drive}:\\docker
echo $MACHINE_STORAGE_PATH

#Check to see if mesa-machine exists
MACHINE_EXISTS=$(docker-machine ls | grep mesa-machine -c)

# Initial VM configuration
if [ $MACHINE_EXISTS -eq 0 ]
then
    # Creating a machine with 2GB of RAM and 2 CPUs
    docker-machine create \
		   -d virtualbox \
		   --virtualbox-memory=2048 \
		   --virtualbox-cpu-count=2 \
		   --virtualbox-disk-size=25000 \
		   mesa-machine
    echo "MESA MACHINE CREATED"
fi

#Setup shared folder, we delete and recrete it as its the best way to make sure it allways exists
    
echo "Stopping for mount point"
# Stop for mounting. Normally its allready stopped
docker-machine stop mesa-machine 2>/dev/null 

# Needs a windows style path to mount.
export HERE=$(echo $PWD | sed -e 's/^\///' -e 's/\//\\/g' -e 's/^./\0:/')
    
export VBOX=$(find /c -name VBoxManage.exe -print -quit 2>/dev/null | head -n 1)

if [[ -z "$VBOX" ]];then
    echo "Warning VBoxManage.exe not found"
    echo 'Check VBoxManage.exe is installed'
    exit 1
fi

# Add docker-machine mount folder
"$VBOX" \
sharedfolder add mesa-machine \
--name mesa_mount \
--hostpath "$HERE/docker_work" \
--automount 2>/dev/null

docker-machine start mesa-machine
echo "MESA MACHINE STARTED"

#Connect terminal to the docker machine to allow running docker commands.
eval "$(docker-machine env mesa-machine)"

# Construct a comand string to pass into the docker-machine
# ssh for starting the container.
START_DOCK='docker run -d --rm --name mesa_dock -p 6158:22 '
START_DOCK+='-v /mesa_mount:/home/docker/docker_work '
START_DOCK+="evbauer/mesa_lean:$tag sleep infinity"
# Needs ssh connection to run the docker command from within the VM
# for the mounting part of the command to work.
docker-machine ssh mesa-machine "$START_DOCK"
docker exec --user root mesa_dock service ssh start

ip=$(docker-machine ip mesa-machine)
# Bind port of docker container inside the machine to local port 20000
echo "password is tcuser"
ssh -Nf -L20000:localhost:6158 docker@$ip
# ssh with X11 forwarding for pgstar.
echo "password is mesa"
ssh -Y -p 20000 docker@localhost

docker kill mesa_dock
docker-machine stop mesa-machine
