# ROS kinetic docker deployment to run ROS on Ubuntu16_04.
FROM ros:kinetic
MAINTAINER mgroshev@pa.uc3m.es

WORKDIR /root
RUN useradd -ms /bin/bash niryo

# Install system dependencies. 
RUN \
  apt-get update && \
  apt-get install -y lsof && \
  apt-get install -y python-rosinstall python-rosinstall-generator && \
  apt-get install -y python-wstool build-essential python-pip xauth && \
  apt-get install -y ros-kinetic-robot-state-publisher \
    ros-kinetic-moveit ros-kinetic-rosbridge-suite ros-kinetic-joy \
    ros-kinetic-ros-control ros-kinetic-ros-controllers \
    ros-kinetic-tf2-web-republisher ros-kinetic-joint-state-publisher-gui &&\
  pip install jsonpickle && \
  rm -rf /var/lib/apt/lists/*

USER niryo
WORKDIR /home/niryo

RUN rosdep update && \
    mkdir -p catkin_ws/src && cd catkin_ws/src && \
    git clone https://github.com/NiryoRobotics/niryo_one_ros.git .

COPY launch/* catkin_ws/src/niryo_one_bringup/launch/

RUN cd catkin_ws && bash -c "source /opt/ros/kinetic/setup.bash && catkin_make"

CMD bash -c "source /opt/ros/kinetic/setup.bash && source catkin_ws/devel/setup.bash && roslaunch niryo_one_bringup twin_control_bringup.launch --screen"
