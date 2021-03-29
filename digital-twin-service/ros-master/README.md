# ROS master

## What is it?

This repository contains the files to lauch a ros master in docker container. 

The ROS Master provides naming and registration services to the rest of the nodes in the ROS system. It tracks publishers and subscribers to topics as well as services. The role of the Master is to enable individual ROS nodes to locate one another. Once these nodes have located each other they communicate with each other peer-to-peer.

## What does this container do?

This container runs `roscore`

## Run it

### Dependencies:
- The ROS master has no dependencies.

### First you will need to build the container. In order to do that, run the build.sh script as sudo:
- `sudo ./build.sh`
- note: It will take some time to build the image because we have to assemble a ROS melodic image.

### This will build the `niryo-ros-master` docker image. Verify that the image is present by running:
- `sudo docker image ls`

### Docker run example
In this folder we also provide a docker run example. 

The run_example.sh is optimized to running the Digital Twin service on a single host. For that reason it uses the docker host network and all the remaning modules (e.g., sim-drivers, control, motion planning ) of the Digital Twin service are added on 127.0.0.1.

To run the ros master:
- `sudo ./run_example.sh`
- Verify that the container is up and running:
    - `sudo docker ps` - in the output you should be able to see the `master` container up and running
