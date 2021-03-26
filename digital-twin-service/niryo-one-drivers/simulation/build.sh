#!/bin/bash

#Assemble docker image. 
echo 'Remember that you need to list and add your xauth keys into the Dockerfile for this to work.'


XAUTH_KEYS_="$(xauth list $HOSTNAME/unix:0)"
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
sudo docker build . -t niryo-sim-drivers --build-arg "XAUTH_KEYS_=$XAUTH_KEYS_"
