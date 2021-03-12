#!/bin/bash
# Assemble docker image. 
echo 'Remember that you need to list and add your xauth keys into the Dockerfile for this to work.'

# 5TONIC Networking settings
ROS_MASTER_URI="http://169.254.210.4:11311"
ROS_IP="169.254.210.2"

# Lab Networking settings
#ROS_MASTER_URI="http://10.0.2.193:11311"
#ROS_IP="10.0.2.195"


XAUTH_KEYS_="$(xauth list $HOSTNAME/unix:0)"
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
sudo docker build . -t niryo-one-motion --build-arg "XAUTH_KEYS_=$XAUTH_KEYS_"

rm $XAUTH && touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

# Networking settings phisical robot
#sudo docker run \
#	--hostname niryo-one-motion \
#	-it \
#	--rm \
#	--net=robot_eth_macvlan \
#        --ip=169.254.210.2 \
#	-e DISPLAY=$DISPLAY \
#        -e ROS_MASTER_URI=$ROS_MASTER_URI \
#        -e ROS_IP=$ROS_IP \
#	-e XAUTHORITY=$XAUTH \
#	-v $XSOCK:$XSOCK  \
#	-v $XAUTH:$XAUTH \
#	--add-host niryo-one-motion:127.0.0.1 \
#	--add-host coppeliaSim:127.0.0.1 \
#        --add-host niryo-desktop:169.254.200.200 \
#        --add-host niryo-one-control:169.254.210.1 \
#        --add-host niryo-one-interface:169.254.210.3 \
#        --add-host niryo-one-sim:169.254.210.4 \
#	niryo-one-control:latest \
#  	bash
#	--user root \

# Networking settings simulated robot
#sudo docker run \
#        --hostname niryo-one-motion \
#        -it \
#        --rm \
#        --net=robot_eth_macvlan \
#        --ip=10.0.2.195 \
#        -e DISPLAY=$DISPLAY \
#        -e ROS_MASTER_URI=$ROS_MASTER_URI \
#        -e ROS_IP=$ROS_IP \
#        -e XAUTHORITY=$XAUTH \
#        -v $XSOCK:$XSOCK  \
#        -v $XAUTH:$XAUTH \
#        --add-host niryo-one-motion:127.0.0.1 \
#        --add-host coppeliaSim:127.0.0.1 \
#        --add-host niryo-desktop:169.254.200.200 \
#        --add-host niryo-one-control:10.0.2.194 \
#        --add-host niryo-one-interface:10.0.2.196 \
#        --add-host niryo-one-sim:10.0.2.193 \
#        --add-host dtwin-web:10.0.2.198 \
#        --add-host dtwin:10.0.2.197 \
#        niryo-one-motion:latest \
#       bash
#       --user root \
