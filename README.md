# Digital Twin Application @ 5G-DIVE Project
This repository comprises the code developed and integrated in 5G-DIVE project
in order to implement the Digital Twin use case.

Currently, this use case uses the [Niryo One](https://niryo.com/niryo-one/)
robot arm and the [CoppeliaSim](https://www.coppeliarobotics.com/) robot
simulator.

## Version
 - 0.1.0beta1

## Requirements
 - Ubuntu 16.04 (or newer version - 18.04, 20.04)
 - PTPD (if you want distributed deployment between multiple hosts)
 - Docker
 - Docker compose

## Getting Started
 ### Digital Twin service description
 The Digital Twin service is composed of 6 different modules:
 - ROS master: The ROS Master provides naming and registration services to the rest of the modules in the Digital Twin service (detailed info [here](http://wiki.ros.org/Master)).
 - ROS Drivers: Porvides the basic sensor and actuator functionalities of the robot arm (detailed info [here](./digital-twin-service/niryo-one-drivers/README.md)).
 - Robot Stack: The robot stack composed of Control, Motion Planning and Interface modules. (detailed info [here](./digital-twin-service/niryo-one-stack/README.md)).
 - Digital Replica: Provides the virtual object that replicates the behavior of the Niryo One robot arm (detailed info [here](./digital-twin-service/digital-replica/README.md)).
 - Web interface: GUI for remote operation (detailed info [here](./digital-twin-service/web-interface/README.md)).
 - Replay feature: Replays last 30 seconds of the robot remote operation in a separate virtual object. (detailed info [here](./digital-twin-service/replay-feature/README.md)).
 ### Install Requirements
 - Install fresh Ubuntu 16.04, 18.04 or 20.04 Desktop (in a VM or as native OS)
 - Install Docker Engine (tutorial [here](https://docs.docker.com/engine/install/ubuntu/))
 - Install Docker Compose (tutorial [here](https://docs.docker.com/compose/install/))
 - Clone this git repo 
 
 ### Run Digital Twin app (with a simulated Nyrio One robot instance)
 - Launch the Niryo One ROS Stack for a single simulated instance
   - Before launching the container you need to set the IP address of the CoppeliaSim and controller containers
   - Launch Niryo One simulation container (tutorial [here](./niryo-one-sim/full-stack/README.md))
   - A visual representation of the simulated robot will be launched in RViz

 - Launch CoppeliaSim container (tutorial [here](./digital-twin-app/coppeliasim-container/README.md))
   - Before launching the container you need to set the IP address of the Niryo One simulation container
   - A visual representation of the CoppeliaSim will be launched

 - Launch the Controller and Calibration container (tutorial [here](./digital-twin-app/controller-and-calibration-container/README.md))
   - Before launching the container you need to set the IP address of the Niryo One simulation container

 - At this point, you should see, in both the RViz and the CoppeliaSim,
   the Niryo One representation executing a set of movements
   fully synchronized.
 
 ### Run Digital Twin app (with a physical Nyrio One robot)
 - Start the phisical Niryo One robot
 - Connect Niryo One Studio and Calibrate the robot
 - Synchronize the clocks between the robot and the remote machine using ptpd
    - Install ptpd: ```sudo apt install ptpd```
    - On the robot: ```sudo ptpd -s -V -i <interface_name>```
    - On the remote machine: ```sudo ptpd -V -i wlp2s0 -m```
 - Launch Digital twin container (tutorial [here](./digital-twin-app/coppeliasim-container/README.md))
    - As the robot is a different machine, you will need to configure the ROS_IP, the ROS_MASTER, and setup the host IPs for the Niryo One phisical robot and the Digital twin container inside the script ./run_container.
 - From Niryo One studio disable the learning mode and your robot is ready to be controled

## DISCLAIMER
The modules provided in this repository are distributed in the hope that they
will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.
See the License section for more details.

## License
The modules provided in this repository are distributed under a license.
The full license agreement can be found in the file LICENSE
in this distribution.
This software may not be copied, modified, sold or distributed other than
expressed in the named license agreement.
