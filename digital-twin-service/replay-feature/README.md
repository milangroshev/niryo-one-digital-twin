# Niryo One Replay. 

## What is this?

By the Replay feature, we refer to another digital twin replica playing back the movements performed by the physical robotic arm, during a given time interval (e.g., look-back on the last 30s) and at a specified movement speed.

This feature is useful for failure analysis and debugging in I4.0 environments, allowing an operator to carefully review the past robot movement that led to a malfunction. 

## Run

Run the containers specifying the following settings (environment variables specified in the docker-compose file):
- REPLICA_HZ: the frequency/speed at which the robot replica will replay
- REPLAY_DURATION: duration of the replay sequence in seconds

### Dependencies
- The Digital Twin Replay features depends on:
   - Digital Twin app (and related dependencies)
   - Zenoh router (v0.5.0-beta.5) 


Make sure these dependencies are up and running before running the container.
Use docker-compose to run it.  

### How to use it?
- Make sure everything is running, the Coppelia SIM GUI is responding and that the digital twin robot is calibrated.
- Move the Digital Twin robot using the Web controller for at least the number seconds specified beforer.  
- Press the "Start" button in the Replay menu of the Web controller interface. 
  From this point on, the Replay module will continuosly publish the latest joint states in a ROS topic associated to a replay robot replica. 
- Go to the CoppeliaSIM GUI and manually add (drag and drop) from the menu on the left the Niryo-One-Replay simulated robot to the scenario. 
- The Replay replica will start playing back the movements.
