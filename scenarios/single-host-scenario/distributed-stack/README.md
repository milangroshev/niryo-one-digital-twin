# Niryo One Digital Twin service deployment on a single host with distributed robot stack. 

## What is this?

This repository contains the necessary files to run the Niryo One Digital Twin service using Docker compose, on a single host with distributed robot stack. Distributed robot stack means that for every module of the [Niryo One Stack](../../../digital-twin-service/niryo-one-stack) (Control, Motion, Interface), the deployment will have separate docker container. 

## What does this docker compose do?

The docker compose builds and runs the Niryo One Digital Twin service for you. The [docker-compose.yml](./docker-compose.yml) contains all the needed configuration to launch the the service on localhost (using the host docker network).

## Run it?

### You will need to run docker-compose. In order to do that, run:
- `sudo docker-compose up`
- note: It will take some time to build the images because we have to assemble a ROS melodic image, install the Niryo One dependencies and install the Niryo One ROS for each of the modules that compose the service

Additional docker-compose useful commands:
- `sudo docker-compose build` : re-builds all the containers
- `sudo docker-compose up -d` : runs the service in detached mode
- `sudo docker-compose down` : brings the service down
- `sudo docker-compose up <name of service from docker-compose.yml file>` : brings up just one specific container

## How to use it?

Once the service is deployed you will have access to two different GUI.
Docker-compose will setup a network and assign an arbitrary IP to each container/service.
You can inspect the network and find out about the IPs with this command:
`sudo docker network inspect distributed-stack_digital-twin-service`

### Digital replica GUI:
- Open your browser and navigate to `<dtwin_service_ip_address>:6901`
- Insert as password: `netcom;`
- Once the GUI is available double click the desktop script `run_coppelia.sh`
- This will open CoppeliaSim. Once you are inside:
    - press the play button
    - and click twice on the + icon of the GUI
- You should see the Niryo One digital Replica going in down

### Web interface:
- Open your browser and navigate to `<web_service_ip_address>:8080`
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
