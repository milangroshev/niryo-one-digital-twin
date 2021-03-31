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
 The Digital Twin [service](./digital-twin-service/) is composed of 6 different modules:
 - ROS master: The ROS Master provides naming and registration services to the rest of the modules in the Digital Twin service (detailed info [here](./digital-twin-service/ros-master/)).
 - ROS Drivers: Porvides the basic sensor and actuator functionalities of the robot arm (detailed info [here](./digital-twin-service/niryo-one-drivers/)).
 - Robot Stack: The robot stack composed of Control, Motion Planning and Interface modules. (detailed info [here](./digital-twin-service/niryo-one-stack/)).
 - Digital Replica: Provides the virtual object that replicates the behavior of the Niryo One robot arm (detailed info [here](./digital-twin-service/digital-replica/)).
 - Web interface: GUI for remote operation (detailed info [here](./digital-twin-service/web-interface/)).
 - Replay feature: Replays last 30 seconds of the robot remote operation in a separate virtual object. (detailed info [here](./digital-twin-service/replay-feature/)).
 ### Install Requirements
 - Install fresh Ubuntu 16.04, 18.04 or 20.04 Desktop (in a VM or as native OS)
 - Install Docker Engine (tutorial [here](https://docs.docker.com/engine/install/ubuntu/))
 - Install Docker Compose (tutorial [here](https://docs.docker.com/compose/install/))
 - Clone this git repo 
 
 ### Run Digital Twin service
 - The scenarios [folder](./scenarios/) is composed of different deployment options for the Digital Twin service.
    - single host scenarios (tutorial [here](./scenarios/single-host-scenario/)) ![#00FF00](https://via.placeholder.com/15/00ff00/000000?text=+) not availabe
    - multiple hosts scenarios (tutorial [here](./scenarios/multi-host-scenario/)) ![#f03c15](https://via.placeholder.com/15/f03c15/000000?text=+) not availabe
    - 5g-dive scenario (tutorial [here](./scenarios/5g-dive/)) ![#f03c15](https://via.placeholder.com/15/f03c15/000000?text=+) not availabe
 
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
