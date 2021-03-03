FROM arm32v7/ros:kinetic
MAINTAINER cmagalha@pa.uc3m.es

WORKDIR /root
RUN useradd -ms /bin/bash niryo-drivers

RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y ros-kinetic-moveit ros-kinetic-robot-state-publisher ros-kinetic-rosbridge-suite ros-kinetic-joy ros-kinetic-ros-control ros-kinetic-ros-controllers ros-kinetic-tf2-web-republisher ros-kinetic-joint-state-publisher-gui python-pip && \
  rm -rf /var/lib/apt/lists/*

RUN pip install RPi.GPIO && pip install flask && pip install pymodbus

RUN \
  git clone https://github.com/WiringPi/WiringPi.git && \
  cd WiringPi && \
  ./build

RUN useradd -ms /bin/bash niryo

USER niryo
WORKDIR /home/niryo

RUN \
  mkdir -p catkin_ws/src && \
  cd catkin_ws/src && \
  git clone https://github.com/NiryoRobotics/niryo_one_ros.git .

RUN \
  cd catkin_ws && \
  bash -c "source /opt/ros/kinetic/setup.bash && catkin_make"

RUN \
  cd catkin_ws/src/niryo_one_bringup/config && \
  mv rpi_ros_processes.yaml rpi_ros_processes.yaml_backup && \
  sed -n "/    - name: 'robot_commander'/q;p" rpi_ros_processes.yaml_backup > rpi_ros_processes.yaml

RUN \
  cd catkin_ws/src/niryo_one_bringup/launch && \
  sed -i "s/<param name=\"wifi_manager_enabled\"  type=\"boolean\" value=\"true\" \/>/<param name=\"wifi_manager_enabled\"  type=\"boolean\" value=\"false\" \/>/g" rpi_setup.launch

RUN mkdir niryo_one_saved_values
COPY niryo_one_saved_values/* /home/niryo/niryo_one_saved_values/
COPY launch/* /home/niryo/catkin_ws/src/niryo_one_bringup/launch/

USER root
CMD bash -c "source /home/niryo/catkin_ws/devel/setup.bash && roslaunch niryo_one_bringup drivers.launch"
