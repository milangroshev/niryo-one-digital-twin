#!/bin/bash
set -e
  
rosnode_list_output_txt="$1"

source /opt/ros/melodic/setup.bash
rosnode_list=`cat $rosnode_list_output_txt`
echo $rosnode_list

ROSNODE_LIST_OUTPUT=
until [ "$ROSNODE_LIST_OUTPUT" == "$rosnode_list" ] 
do
  ROSNODE_LIST_OUTPUT=$(rosnode list)
  echo $ROSNODE_LIST_OUTPUT #debug
  sleep 1
done 
echo "Node is up"