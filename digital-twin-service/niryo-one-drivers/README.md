# Niryo One ROS Drivers

## What is this?

This repository contains the necessary files to run the Niryo One ROS drivers.

The Niryo One ROS drivers are the lowest-level module that directly interacts with the robot hardware and is responsible for:
- making available sensor data andoperational states to the other modules
- executinginstructions or navigation commands received from thecontrol module. 

Due to the tight relation with the robots hardware, this module must be deployed in the robot.

This repo provides two options to run the robot drivers:
- robot: run them as container on the physical Niryo One (tutorial [here](./robot/)) ![#f03c15](https://via.placeholder.com/15/f03c15/000000?text=+) Not available 
- simulation: run them as simulated drivers in any commodoty hardware (tutorial [here](./simulation/)) ![#00FF00](https://via.placeholder.com/15/00ff00/000000?text=+) Available
