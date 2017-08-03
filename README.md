# DockerMESA

MESA in a Docker Container for easy installation

## Prerequisites

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

## Running

### OS X

Start Docker.

In your terminal, navigate to where you want to set up your MESA working directory.

Clone this repository.

	git clone https://github.com/evbauer/DockerMESA.git

Run the script for Mac.

	cd DockerMESA && ./mac_dockerMESA.sh

### Windows 10

Start Docker and Xming.

Open Git Bash and navigate to where you want to set up your MESA working directory.

Clone this repository.

	git clone https://github.com/evbauer/DockerMESA.git

Run the script for Windows.

	cd DockerMESA && ./win_dockerMESA.sh

The Windows script currently operates by SSHing into the Docker container for nice handling of X11 forwarding to your desktop. The password for user "docker" is `mesa`. 