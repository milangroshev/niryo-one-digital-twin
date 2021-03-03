# Niryo One control layer

## What is it?

This repository contains the code to lauch a Niryo One control layer in docker container. 

## Run it

You will need to setup the host IPs for the niryo-one-sim, niryo-one-motion and niryo-one-interface inside the script `./run_container` based on your local configuration.
In addition, you will need to set up a static ip addres for the driver simulation container (--ip) from the subnet of the macvlan docker network that you created. Also the ROS_MASTER_URI and the ROS_IP need to be set.  

In our run_container.sh example:
  - the container static ip: ```**--ip=10.0.2.196**``` ```**-e ROS_IP=10.0.2.196**```
  - the ROS master pointing to the niryo-one-sim: ```**-e ROS_MASTER_URI=10.0.2.193**``` 
  - the niryo-one-control static ip: ```**--add-host niryo-one-sim:10.0.2.193**``` 
  - the niryo-one-motion static ip: ```**--add-host niryo-one-motion:10.0.2.195**```
  - the niryo-one-sim static ip: ```**--add-host niryo-one-sim:10.0.2.193**```   

Once you have done that, install Docker in your machine and execute the `./run_container` script.

Since Niryo One ROS is optimized for ROS Kinetic we recomend that your docker host is on Ubuntun 16.04.

It will take some time to setup because we have to assemble a ROS kinetic image. 


note: If you decide to distribute the Niryo One ROS stack between different phisical machines, you will need to synchronize the clocks. This can be done very efficiently by setting a ptpd master on one docker host and connecting the other phisical machines like clients.  

`ptpd -V -m -i <interface> # Start a ptpd master.`
`ptpd -V -s -i <interface> # Start a ptpd slave.`
