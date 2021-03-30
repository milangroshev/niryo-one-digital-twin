# Niryo One ROS Web Interface. 

## What is this?

This repository contains the necessary files to deploy a web servce to perform remote operation of the Niryo One Robotic Arm.

Upon boot of the container, a web server will be available at port 8080.

## What does this container do?

This container runs web application writen in python that uses rospy library to interact with the phisical robot for remote operation. The GUI contains mechanisams for remote control, robot callibration and replay feature. 

## Run it?

### Dependencies:
- The Niryo One ROS Web Interface depend on:
    - master (tutorial [here](../../ros-master/)).
    - sim-drivers (tutorial [here](../../niryo-one-drivers/simulation/)).
    - ![#f03c15](https://via.placeholder.com/15/f03c15/000000?text=+) control (tutorial [here](../niryo-one-stack/niryo-one-control/)).
    - ![#f03c15](https://via.placeholder.com/15/f03c15/000000?text=+) motion (tutorial [here](../niryo-one-stack/niryo-one-motion/)).
    - ![#f03c15](https://via.placeholder.com/15/f03c15/000000?text=+) interface (tutorial [here](../niryo-one-stack/niryo-one-interface/)).
    - digital replica (tutorial [here](../digital-replica/)).

![#f03c15](https://via.placeholder.com/15/f03c15/000000?text=+) instead of running each module separatly (control, motion, interface) you can run the Niryo One Stack in a single container (tutorial [here](../niryo-one-stack/niryo-one-stack/)).
 
note: be sure that all the dependencies are running before you run the Niryo One ROS Web Interface container !!!

### First you will need to build the container. In order to do that, run the build.sh script as sudo:
- `sudo ./build.sh`
- note: It will take some time to build the image because we have to assemble a ROS melodic image, install the Niryo One dependencies and install the Niryo One ROS  

### This will build the `niryo-one-web` docker image. Verify that the image is present by running:
- `sudo docker image ls`

### Docker run example
In this folder we also provide a docker run example. 

The run_example.sh is optimized to running the Digital Twin service on a single host. For that reason it uses the docker host network and all the remaning modules (e.g., master, control, motion planning ) of the Digital Twin service are added on 127.0.0.1.

To run the Niryo One ROS Web Interface:
- `sudo ./run_example.sh`
- Verify that the container is up and running:
    - `sudo docker ps` - in the output you should be able to see the `web-interface` container up and running

### How to use it?

- Open your browser and navigate to `<host_machine_ip_address>:8080`
- Once the GUI is available you need to:
    - Click the `Connect` button in order to connected the GUI to the robot. If the connection is sucessfull you should be able to see `Connection Status: OPEN`.
    - Click the `Manual` Calibration buttion to get the robot in operational state. 
    - Note: if you use simulated robot, you can only perform `Manual` calibration, while if you use the phisical robot the first calibration needs to be `Auto`
- After the calibration is done, you can start interacting with the robot. Press the button `Go to (0,0,0)`.  If the Digital Twin service is deployed corectly, you should be able to see the Digital replica in the CoppeliaSim going in position (0,0,0)
- Choose your level of interaction by selecting the Layer drop down manu.
    - Interface control loop: 500ms
    - Motion Planning control loop: 400ms
    - Control control loop: 20ms
- Move each individual joint of the robot by pressing the buttons in the bottom left box named Move Joints.
- You can also control the robot by using the Remote Control box. 
    - Click and hold with the mouse on the robot gripper of the robot figure.
    - Now while holding the click move the robot up or down.
    - Rotate the robot by using the rotation figures. 
- Move the jointss of the robot my pressing the buttons in the right botom box called Move Joints.
