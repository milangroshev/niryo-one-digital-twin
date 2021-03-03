# Niryo One distributed ROS stack. 

## What is this?

This repository contains the necessary files to distribute the Niryo One ROS stack.
 
The niryo-one-control contains ROS based controllers that: (i) receive current position from the drivers, (ii) Interpolates the trajectory to get the next postion command and (iii) sends the position command to the driver. This layer coresponds to the Control layer of the Niryo one architechure.   

The niryo-one-motion contains ROS packages that are responsable for finding inverse kinematics and building a path for the robot. We use the well-known ROS Moveit package for this layer. This layer coresponds to the Motion player layer of the Niryo one architechure.   

The niryo-one-interface represents level interface between the client (you or another machine) and the underlying robot commands. This layer coresponds to the commander and external layer of the Niryo one architechure.

## How to use it?

### Network configuration

First of all, you will need to have a ROS network operational with a well known host as ROS_MASTER. 
In order to achive this using docker you will need to create a macvlan network.

IMPORTNAT: please modify the host ethernet interface - parent, ip-range and aux-address values based on your configuration. For the pourpose of this example we will use host ethernet interface ```**enp0s3**``` that has ip addreess in the subnet ```**10.0.2.0/24**```. We will alocate to the containers ip address from the pool ```**10.0.2.192/27**``` and host ```**10.0.2.223**``` will be excluded from this pool.  

 - create macvlan network: ```sudo docker network create -d macvlan -o parent=enp0s3 --subnet 10.0.2.0/24 --ip-range 10.0.2.192/27 --aux-address 'host=10.0.2.223' robot_eth_macvlan```
 - enable the docker host to communicate with the containers over the macvlan:
  - create a new macvlan interface on the host: ```sudo ip link add mynet-shim link enp0s3 type macvlan  mode bridge ```
  - configure the interface with the address we reserved bring it up: ```sudo ip addr add 10.0.2.223/32 dev mynet-shim  sudo ip link set mynet-shim up```
  - tell the docker host to use that interface when communicating with the containers: ```sudo ip route add 10.0.2.192/27 dev mynet-shim```

### Niryo One drivers

Before running the Niryo One distributed ROS stack we will need to run the Niryo one robot drivers. 

We have two options for running the the robot drivers.

#### Option1: Simulated robot drivers
Launch Niryo One drover-only simulation container (tutorial [here](https://github.com/milangroshev/niryo-digital-twin/blob/master/niryo-one-sim/drivers-only/README.md))

#### Option2: Niryo One robot

TO BE DONE!!!!

### Niryo One ROS distributed stack

Launch Niryo One Control layer (tutorial [here](https://github.com/milangroshev/niryo-digital-twin/blob/master/digital-twin-app/niryo-one-microservices/niryo-one-control/README.md))

Launch Niryo One Motion layer (tutorial [here](https://github.com/milangroshev/niryo-digital-twin/blob/master/digital-twin-app/niryo-one-microservices/niryo-one-motion/README.md))

Launch Niryo One Interface layer (tutorial [here](https://github.com/milangroshev/niryo-digital-twin/blob/master/digital-twin-app/niryo-one-microservices/niryo-one-interface/README.md))

Launch the Digital Twin application (tutorial [here](https://github.com/milangroshev/niryo-digital-twin/blob/master/digital-twin-app/coppeliasim-container/README.md))
