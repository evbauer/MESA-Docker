
export DISPLAY=localhost:0.0

docker run -d --rm \
       -p 6158:22 \
       -v $PWD/docker_work:/home/docker/docker_work \
       evbauer/mesa9793_installed:0.2

ssh -X -p 6158 docker@localhost

# Should probably find a more elegant way to clean up eventually.
yes | docker container prune
