# Niryo One ROS controlled simulation. 

## What is this?

This repository contains the necessary files to deploy and execute a Niryo One digital twin application. 

The digital twin monitors the state of a Niryo One robot using ROS topics, specifically the /joint_states and the /joy topics using the ROS interface for CoppeliaSim. 

The information recovered from these topics is then used to actuate a 3D model of a Niryo One included with CoppeliaSim and to obtain additional information that is not provided by the robot itself. 

The simulation allows the retrieval of the torque exerted per joint, which could potentially be used in a predictive model to infer the reliability of the joints over time.

In addition to this, the model serves to the network the simulation time in seconds and the state of the gripper, which is limited to the larger one. 

## How to use it?

First of all, you will need to have a ROS network operational with a well known host as ROS_MASTER. 

Then you will need to configure the `run_container.sh` script with the IP of the ROS_MASTER if it cannot be resolved and other hostnames that have to be included in the `/etc/hosts` file. 

Any machine that will make use of the services of this digital twin on the ROS network needs to be resolvable, either via DNS or `/etc/hosts`.  

[Example of ROS network](network_diagram.png)

An example of a network setup, used with in hostpot mode with the Niryo One is the one of the included image. 

The you will need an Internet connection on your host machine to build the image. 
If this is handled, then just execute `run_container.sh` and wait until CoppeliaSim appears on your desktop environment. 

This script will do essentially three things:
1. It will build your Docker image. 
2. It will forward X11 from the container to your host machine. 
3. It will run a container with the latest image in sharing your host's networking namespace.  

An important note is that in order for the GUI to appear, your system needs to support X11 forwarding. 

Once CoppeliaSim is up and running, review the logs to verify that the ROS interface has been loaded during initialization. If you see an error it most likely means that your ROS_MASTER cannot be reached. 

Run the simulation and adapt the speed accordingly to achieve realtime feedback.

If you find errors at this point, it is likely that something is failing with the connection to the robot or the control node. 

Check out [my other repository](https://github.com/jairomer/niryo-one-simulation-controller) if you want to execute the integration tests for the digital twin. 
