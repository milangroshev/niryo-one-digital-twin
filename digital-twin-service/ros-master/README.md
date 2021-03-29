# ROS master

## What is it?

This repository contains the files to lauch a ros master in docker container. 

The ROS Master provides naming and registration services to the rest of the nodes in the ROS system. It tracks publishers and subscribers to topics as well as services. The role of the Master is to enable individual ROS nodes to locate one another. Once these nodes have located each other they communicate with each other peer-to-peer.

## What does this container do?

This container runs the `roscore` command

## Run it

### Dependencies:
- The ROS master has no dependencies.

### First you will need to build the container. In order to do that, run the build.sh script as sudo:
- `sudo ./build.sh`
- note: It will take some time to build the image because we have to assemble a ROS melodic image.
