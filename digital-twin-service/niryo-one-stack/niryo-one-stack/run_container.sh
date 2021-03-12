#!/bin/bash
# Assemble docker image. 
echo 'Remember that you need to list and add your xauth keys into the Dockerfile for this to work.'

XAUTH_KEYS_="$(xauth list $HOSTNAME/unix:0)"
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
sudo docker build . -t niryo-one-sim --build-arg "XAUTH_KEYS_=$XAUTH_KEYS_"

rm $XAUTH && touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

# Networking settings
sudo docker run \
	--hostname niryo-one-sim \
	-it \
	--rm \
	--net=host \
        -e ROS_IP=0.0.0.0 \
        -e ROS_MASTER_URI=http://127.0.0.1:11311 \
	-e DISPLAY=$DISPLAY \
	-e XAUTHORITY=$XAUTH \
	-v $XSOCK:$XSOCK  \
	-v $XAUTH:$XAUTH \
	--add-host niryo-one-sim:127.0.0.1 \
	--add-host dtwin:127.0.0.1 \
	niryo-one-sim:latest \
#  	bash
#	--user root \
