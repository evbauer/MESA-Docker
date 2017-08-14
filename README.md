# DockerMESA

MESA in a Docker Container for easy installation

## Prerequisites

At least 8 GB of RAM and 10 GB of free disk space are recommended.
The Docker image is about 5 GB, and you'll also need space to store any MESA output.
If you have < 8 GB of RAM, you may need to tune your Docker settings to allocate less than the default of 2GB to Docker for it to start.
If you have ≥ 8 GB of RAM, you may want to consider tweaking your Docker settings to allow for more than the default 2 GB for containers.

###  OS X
Install XQuartz (2.7.10 or newer required). https://www.xquartz.org/

In XQuartz Preferences->Security, check the box for "Allow connections from network clients". Restart XQuartz.

### Windows 10

Install Xming. https://sourceforge.net/projects/xming/

Install Git Bash. https://git-for-windows.github.io/

Running Docker may require enabling VT-x/AMD-v in BIOS/UEFI.
I also had to turn off "fast boot" on my particular ASUS motherboard, but I think this is uncommon.


## Install Docker

### OS X, Windows 10 Pro, Enterprise, and Education

Install Docker Community Edition:
https://www.docker.com/community-edition

### Windows 10 Home (and possibly older Windows versions)

Install Docker Toolbox: https://www.docker.com/products/docker-toolbox

Windows 10 Home does not enable hyper-v, which is required for Docker Community Edition. Docker Toolbox provides a workaround. This is not optimal for performance, but MESA should run.


## Setup

In your terminal, navigate to where you want to set up your MESA working directory, and clone this repository.

	git clone https://github.com/evbauer/DockerMESA.git


## Running

### OS X

Start Docker.

In your terminal, navigate to your DockerMESA directory, and run the script for Mac.

	./mac_dockerMESA.sh

You should now be inside a docker container with MESA installed and ready to go. Once you've done your work, you can cleanly end the session simply by typing

	exit
	
Anything you saved in the `~/docker_work` directory inside the container will persist in the `DockerMESA/docker_work` directory outside the container.


### Windows 10 (Pro, Enterprise, Education)

Start Docker and Xming.

Open Git Bash and navigate to your DockerMESA directory, then run the script for Windows.

	./win_dockerMESA.sh

The Windows script currently operates by SSHing into the Docker container for nice handling of X11 forwarding to your desktop. The password for user "docker" is `mesa`. 

You should now be inside a docker container with MESA installed and ready to go. Once you've done your work, you can cleanly end the session simply by typing

	exit

Anything you saved in the `~/docker_work` directory inside the container will persist in the `DockerMESA/docker_work` directory outside the container.

Cleanly detaching from the container may require quitting XQuartz/Xming if pgstar windows were used in a MESA run.

### Windows 10 Home (and possibly older Windows versions)

Start Xming.

Open Git Bash and navigate to your DockerMESA directory, then run the script for Windows Home.

	./win_home_dockerMESA.sh
	
The first time this script runs it may take a few minutes to configure the virtual machine.

This script starts a Linux virtual machine, starts the MESA Docker container inside that VM, and then SSH tunnels through both layers into the Docker container with X11 forwarding so you can see your `pgstar` windows. Since there are two levels of SSH performed here, you have to enter a password twice. The first password is `tcuser`, and the second password is `mesa`. 

You should now be inside a docker container with MESA installed and ready to go. Once you've done your work, you can cleanly end the session simply by typing

	exit

Anything you saved in the `~/docker_work` directory inside the container will persist in the `DockerMESA/docker_work` directory outside the container.

Cleanly detaching from the container may require quitting XQuartz/Xming if pgstar windows were used in a MESA run.

## Removing DockerMESA

Docker will automatically cache the 5 GB image the first time you call the script, so you won't have to download it every time you run. If you want to free up that space on your hard drive, you can see a list of all your cached images by typing

	docker images

This will show you all the images and how much space they are taking up. You should be able to remove the DockerMESA image with the command

	docker rmi evbauer/mesa_lean:9793.01

### Windows 10 Home

For those using Docker Toolbox instead of Docker Community Edition, you may want to remove the entire virtual machine with

	docker-machine rm mesa-machine

### OS X Warning

It has been documented that Docker for Mac fails to shrink its disk usage even after images are totally removed (https://github.com/docker/for-mac/issues/371). If you need to get that disk space back, you may need to reset the client: Preferences -> Reset -> Reset to factory defaults. This will remove ALL of your docker containers and images and free up the disk space used by Docker, so be careful if you have any local images that you can't pull from Docker Hub after you reset.

