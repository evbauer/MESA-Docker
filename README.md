# DockerMESA

MESA in a Docker Container for easy installation

## Prerequisites

At least 8 GB of RAM and 10 GB of free disk space is recommended.

###  OS X
Install XQuartz (2.7.10 or newer required). https://www.xquartz.org/

In XQuartz Preferences->Security, check the box for "Allow connections from network clients"

### Windows 10
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