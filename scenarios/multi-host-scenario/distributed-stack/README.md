# Niryo One Digital Twin service deployment on multi-host distributed scenario

## What is this?

This repository contains the necessary files to run the Niryo One Digital Twin stack deploying the containers in different hosts, using Docker Compose and the Docker Swarm node. 

## Pre-requisites

Each machine running the containers must have the following components installed: 
* Docker
* Docker-compose (v12.6.8)

Also, in absence of a centralized registry, the Docker images composing the service need to be already present in the machine (therefore you need to build each service image manually for every host machine before running the stack). 

## Hosts configuration

We are going to use our testbed set of VMs in order to explain the procedure to configure the hosts properly and then perform the deployment. 

This is the multi-host setup: 
* ROBOT (10.5.98.108): `master`, `drivers`
* CONTROL (10.5.98.107): `control`
* MOTION(10.5.98.106): `motion`
* INTERFACE (10.5.98.105): `interface`
* APP (10.5.98.109): `dtwin`, `web`

Each VM will run different services of the stack as indicated after the double column.  

First configure the controller/master node (10.5.98.108 in our case) by initializing the Docker swarm like this: `docker swarm init`. 

This command will be displayed upon success: `docker swarm join --token SWMTKN-1-4pxdygt5zbrytu30z1w8ddsv6ur45k523zqtnsyjta9jglg51o-9qa0q3r8z0s9jutixtcvykhze 10.5.98.108:2377` with the correct token.

Copy paste this command to the VMs you want to add as workers/slave nodes (CONTROL, MOTION PLANNING...). 

From the master machine, you can see the nodes belonging to the Swarm using this: `docker node ls`.

Add a label to each node so that the Docker Swarm orchestrator knows where to deploy each service, as specified in the Docker-compose file of the Digital Twin stack under the key `placement`.  
You can run this command in the master for each node: `docker node update --label-add module=motion <node_id>`, where `module` is the key and `motion` is the label value. Refer to the multi-host setup example for the key-value mapping.

## Deployment

Eventually run the containers launching this command in the master node: 
`docker stack deploy -c docker-compose.yml digital-twin-stack`
Inspect the status of each Docker-compose service doing like this: 
`docker stack ps digital-twin-stack`.
To remove the stack, use: 
`docker stack rm digital-twin-stack`.

TO DO: ADD OVERLAY NETWORK CONFIGURATION 





