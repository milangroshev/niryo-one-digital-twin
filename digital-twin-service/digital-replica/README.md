# Niryo One Digital Twin. 

## What is this?

This repository contains the necessary files to run the Niryo One Digital Twin replica. 

The digital twin monitors the state of a Niryo One robot using ROS topics, specifically the /joint_states and the /joy topics using the ROS interface for CoppeliaSim. 

The information recovered from these topics is then used to actuate a 3D model of a Niryo One included with CoppeliaSim and to obtain additional information that is not provided by the robot itself. 

The simulation allows the retrieval of the torque exerted per joint, which could potentially be used in a predictive model to infer the reliability of the joints over time.

In addition to this, the model serves to the network the simulation time in seconds and the state of the gripper, which is limited to the larger one. 

## What does this container do?

This container runs CoppeliaSim with the ROS interface in a VNC container

## Run it?

### Dependencies:
- The Niryo One Digital Twin depend on:
    - master (tutorial [here](../../ros-master/)).
    - sim-drivers (tutorial [here](../../niryo-one-drivers/simulation/)).
    - control (tutorial [here](../niryo-one-stack/niryo-one-control/)).
    - motion (tutorial [here](../niryo-one-stack/niryo-one-motion/)).
    - interface (tutorial [here](../niryo-one-stack/niryo-one-interface/)).

note: instead of running each module separatly (control, motion, interface) you can run the Niryo One Stack in a single container (tutorial [here](../niryo-one-stack/niryo-one-stack/)).
 
note: be sure that all the dependencies are running before you run the Niryo One Digital Twin container

### First you will need to build the container. In order to do that, run the build.sh script as sudo:
- `sudo ./build.sh`
- note: It will take some time to build the image because we have to assemble a ROS melodic image, install the Niryo One dependencies and install the Niryo One ROS  

### This will build the `niryo-one-dtwin` docker image. Verify that the image is present by running:
- `sudo docker image ls`

### Docker run example
In this folder we also provide a docker run example. 

The run_example.sh is optimized to running the Digital Twin service on a single host. For that reason it uses the docker host network and all the remaning modules (e.g., master, control, motion planning ) of the Digital Twin service are added on 127.0.0.1.

To run the Niryo One Digital Twin:
- `sudo ./run_example.sh`
- Verify that the container is up and running:
    - `sudo docker ps` - in the output you should be able to see the `dtwin` container up and running

### How to use it?

- Open your browser and navigate to <host_machine_ip_address:6901>
- Insert as password: netcom;
- Once the GUI is available double click the desktop script `run_coppelia.sh`
- This will open CoppeliaSim. Once you are inside:
    - press the play button
    - and click twice on the + icon of the GUI
- You should see the Niryo One digital Replica going in a down
- To verify that the Digital Twin service works correctly run the web interface (tutorial [here](../web-interface/)).

