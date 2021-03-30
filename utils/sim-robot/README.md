# Niryo One Simulated Robot

## What is it?

This repository contains the files to run a Niryo One simulated robot as docker container. 

## What does this container do?

This container runs the all the ROS nodes to simulate a full version of the Niryo One robot. 

## Run it  

### Dependencies:
- The Niryo One simulated drivers depend on:
    - master (tutorial [here](../../digital-twin-service/ros-master/)).
 
note: be sure that all the dependencies are running before you run the Niryo One simulated robot container

### First you will need to build the container. In order to do that, run the build.sh script as sudo:
- `sudo ./build.sh`
- note: It will take some time to build the image because we have to assemble a ROS melodic image, install the Niryo One dependencies and install the Niryo One ROS  

### This will build the `niryo-one-sim` docker image. Verify that the image is present by running:
- `sudo docker image ls`

### Docker run example
In this folder we also provide a docker run example. 

The run_example.sh is optimized to running the Digital Twin service on a single host. For that reason it uses the docker host network and all the remaning modules (e.g., master, control, motion planning ) of the Digital Twin service are added on 127.0.0.1.

To run the simulated robot:
- `sudo ./run_example.sh`
- Verify that the container is up and running:
    - `sudo docker ps` - in the output you should be able to see the `niryo-sim-robot` container up and running
