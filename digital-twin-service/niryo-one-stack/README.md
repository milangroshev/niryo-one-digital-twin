# Niryo One distributed ROS stack. 

## What is this?

This repository contains the necessary files to build the Niryo One ROS stack.
 
The niryo-one-control contains ROS based controllers that: (i) receive current position from the drivers, (ii) Interpolates the trajectory to get the next postion command and (iii) sends the position command to the driver. This layer coresponds to the Control layer of the Niryo one architechure.   

The niryo-one-motion contains ROS packages that are responsable for finding inverse kinematics and building a path for the robot. We use the well-known ROS Moveit package for this layer. This layer coresponds to the Motion player layer of the Niryo one architechure.   

The niryo-one-interface represents level interface between the client (you or another machine) and the underlying robot commands. This layer coresponds to the commander and external layer of the Niryo one architechure.

The Niryo One ROS stack modules can be deployed in the robot or in the Edge of the network.

This repo provides two options to run the Niryo One ROS stack:
- Distributed, where each module is separate container:
    - Control: (tutorial [here](./digital-twin-service/niryo-one-stack/niryo-one-control/README.md)).
    - Motion Planning: (tutorial [here](./digital-twin-service/niryo-one-stack/niryo-one-motion/README.md)).
    - Interface: (tutorial [here](./digital-twin-service/niryo-one-stack/niryo-one-interface/README.md)).
- Centralized, where all the modules are in single container (tutorial [here](./digital-twin-service/niryo-one-stack/niryo-one-stack/README.md)).

