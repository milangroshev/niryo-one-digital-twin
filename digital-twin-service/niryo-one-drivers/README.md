# Niryo One ROS Drivers

## What is this?

This repository contains the necessary files to run the Niryo One ROS drivers.

The Niryo One ROS drivers are the lowest-level module that directly interacts with the robot hardware and is responsible for:
- making available sensor data andoperational states to the other modules
- executinginstructions or navigation commands received from thecontrol module. 

Due to the tight relation with the robots hardware, this module must be deployed in the robot.

This repo provides two options to run the robot drivers:
- robot: run them as container on the phisical Niryo One (tutorial [here](./digital-twin-service/niryo-one-drivers/robot/)).
- simulation: run them as simulated drivers in any commodoty hardware (tutorial [here](./digital-twin-service/niryo-one-drivers/simulation/)).
