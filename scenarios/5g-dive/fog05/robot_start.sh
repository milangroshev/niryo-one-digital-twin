#!/bin/bash

source /home/niryo/catkin_ws/devel/setup.bash


echo "=== Launch Robot Drivers ==="
roslaunch niryo_one_bringup start_sim_robot_drivers.launch __master:=http://10.9.16.213:11311 &
ROS_PID=$!

echo "=== Robot Drivers PID: ${ROS_PID} ==="

trap cleanup 1 2 3 6

cleanup(){
	echo "=== Kill Robot Drivers ${ROS_PID} ==="

    kill -2 $(ps -o pid= --ppid $ROS_PID)
    kill -2 $ROS_PID

	# screen -S {{ id }} -X quit
	echo "=== Bye ==="
	exit 0
}


wait $ROS_PID
