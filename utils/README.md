# Utilities 

## What is this?

This folder contains different utilities tools for the Niryo One Digital Twin service.

- macvlan: Examplary bash script on how to create docker macvlan network if you want to use it for the multiple host deployment scenario
- niryo-one-urdf: The URDF file of Niryo One robot arm
- sim-robot: run the full simulated robot in single docker container. This container includes: Simulated drivers, Control, Motion Planning and Interface modules (tutorial [here](./sim-robot/))
- docker_hub.sh: Examplary bash script if you want to push the docker images to a private docker hub
- tc_network_config.sh: Bash tool for traffic control using linux tc command. You can add artificial latency and packet loss with this tool
