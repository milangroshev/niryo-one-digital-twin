#!/bin/bash

source /opt/ros/melodic/setup.bash

ros_nodes=($(rosnode list))

#printf '%s\n' "${ros_nodes[@]}"

in_array () {
        local somearray=${1}[@]
        shift
        for SEARCH_VALUE in "$@"; do
            FOUND=false
            for ARRAY_VALUE in ${!somearray}; do
                if [[ $ARRAY_VALUE == $SEARCH_VALUE ]]; then
                        FOUND=true
                        break
                fi
            done
            if ! $FOUND; then
                return 1
            fi
         done
         return 0
}

in_array ros_nodes "/niryo_one_driver" "/niryo_one_tools"
out=$?

while [ $out -eq 1 ]
do
        echo "Required ROS nodes are unavailable - sleeping"
        source /opt/ros/melodic/setup.bash
        ros_nodes=($(rosnode list))
        in_array ros_nodes "/niryo_one_driver" "/niryo_one_tools"
        out=$?
        sleep 1
done

source /opt/ros/melodic/setup.bash
source /home/niryo/catkin_ws/devel/setup.bash
roslaunch niryo_one_bringup twin_control_bringup.launch
