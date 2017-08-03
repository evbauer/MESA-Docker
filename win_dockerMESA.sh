
export DISPLAY=localhost:0.0
# Needs a windows style path to mount.
export HERE=$(echo $PWD | sed -e 's/^\///' -e 's/\//\\/g' -e 's/^./\0:/')

winpty docker run -d --rm \
       -p 6158:22 \
       -v $HERE/docker_work:/home/docker/docker_work \
       evbauer/mesa9793_installed:0.2 \
       sudo service ssh start

ssh -X -p 6158 docker@localhost

# Should probably find a more elegant way to clean up eventually.
yes | docker container prune
