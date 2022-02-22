# ROS melodic docker deployment to run ROS on Ubuntu16_04.
FROM ros:melodic
MAINTAINER mgroshev@pa.uc3m.es

WORKDIR /root
RUN useradd -ms /bin/bash niryo

# Install system dependencies. 
RUN \
  apt-get update && \
  apt-get install -y lsof && \
  apt-get install -y python-rosinstall python-rosinstall-generator && \
  apt-get install -y python-wstool build-essential python-pip xauth && \
  apt-get install -y ros-melodic-robot-state-publisher \
    ros-melodic-moveit ros-melodic-rosbridge-suite ros-melodic-joy \
    ros-melodic-ros-control ros-melodic-ros-controllers \
    ros-melodic-tf2-web-republisher ros-melodic-joint-state-publisher-gui &&\
  pip install jsonpickle numpy flask influxdb && \
  rm -rf /var/lib/apt/lists/*

USER niryo
WORKDIR /home/niryo

RUN rosdep update && \
    mkdir -p catkin_ws/src && cd catkin_ws/src && \
    git clone https://github.com/NiryoRobotics/niryo_one_ros.git .

COPY launch/* catkin_ws/src/niryo_one_bringup/launch/
RUN rm catkin_ws/src/niryo_one_user_interface/scripts/joystick_interface.py
COPY scripts/joystick_interface.py catkin_ws/src/niryo_one_user_interface/scripts/joystick_interface.py

RUN mkdir -p /home/niryo/scripts
COPY scripts/wait-for-ros-nodes.sh /home/niryo/scripts/
COPY scripts/remote-controler-gripper-web-influx.py /home/niryo/catkin_ws/src/niryo_one_bringup/scripts/
COPY scripts/milan-4-cubes-10.csv /home/niryo/catkin_ws/src/niryo_one_bringup/scripts/

RUN cd catkin_ws && bash -c "source /opt/ros/melodic/setup.bash && catkin_make"

WORKDIR /home/niryo/scripts/
USER root
RUN chmod +755 wait-for-ros-nodes.sh
USER niryo

CMD bash -c "./wait-for-ros-nodes.sh"
