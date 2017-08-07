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
Note: Currently only Windows 10 Pro, Enterprise, and Education are supported. Windows 10 Home does not enable hyper-v, and hence Docker Community Edition cannot be installed. Work is underway to find a solution using Docker Toolbox, but it is unclear what level of support will be possible.

Install Xming. https://sourceforge.net/projects/xming/

Install Git Bash. https://git-for-windows.github.io/

Running Docker may require enabling VT-x/AMD-v in BIOS/UEFI, then enabling hyper-v in Windows settings.
I also had to turn off "fast boot" on my particular ASUS motherboard, but I think this is uncommon.

## Install Docker

https://www.docker.com/community-edition

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


### Windows 10

Start Docker and Xming.

Open Git Bash and navigate to your DockerMESA directory, then run the script for Windows.

	./win_dockerMESA.sh

The Windows script currently operates by SSHing into the Docker container for nice handling of X11 forwarding to your desktop. The password for user "docker" is `mesa`. 

You should now be inside a docker container with MESA installed and ready to go. Once you've done your work, you can cleanly end the session simply by typing

	exit

Anything you saved in the `~/docker_work` directory inside the container will persist in the `DockerMESA/docker_work` directory outside the container.


## Removing DockerMESA

Docker will automatically cache the 7.5 GB image the first time you call the script, so you won't have to download it every time you run. If you want to free up that space on your hard drive, you can see a list of all your cached images by typing

	docker images

This will show you all the images and how much space they are taking up. You should be able to remove the DockerMESA image with the command

	rmi evbauer/mesa_lean:9793.01

### OS X Warning

It has been documented that Docker for Mac fails to shrink its disk usage even after images are totally removed (https://github.com/docker/for-mac/issues/371). If you need to get that disk space back, you may need to reset the client: Preferences -> Reset -> Reset to factory defaults. This will remove ALL of your docker containers and images and free up the disk space used by Docker, so be careful if you have any local images that you can't pull from Docker Hub after you reset.