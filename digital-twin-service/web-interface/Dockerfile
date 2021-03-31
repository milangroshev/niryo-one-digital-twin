# ROS melodic docker deployment to run ROS on Ubuntu16_04.
FROM ros:melodic
MAINTAINER cmagalha@pa.uc3m.es

WORKDIR /root
RUN useradd -ms /bin/bash niryo

# Install system dependencies. 
RUN \
  apt-get update && \
  apt-get install -y lsof software-properties-common python-rosinstall python-rosinstall-generator python-wstool build-essential python-pip xauth ros-melodic-robot-state-publisher ros-melodic-moveit ros-melodic-rosbridge-suite ros-melodic-joy ros-melodic-ros-control ros-melodic-ros-controllers ros-melodic-tf2-web-republisher ros-melodic-joint-state-publisher-gui && \
  add-apt-repository ppa:deadsnakes/ppa && \
  apt-get update && \
  apt-get install -y python3.7 python3-pip python3.7-dev && \
  pip install jsonpickle && \
  pip install pyassimp && \
  python3.7 -m pip install --upgrade requests && \
  python3.7 -m pip install --upgrade aiohttp && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

#USER niryo
#WORKDIR /home/niryo

RUN rosdep update && \
    mkdir -p catkin_ws/src && cd catkin_ws/src && \
    git clone https://github.com/NiryoRobotics/niryo_one_ros.git . && \
    cd .. && bash -c "source /opt/ros/melodic/setup.bash && catkin_make"

ADD ./web_interface/ .
COPY scripts/* /root/
RUN chmod +755 wait-for-ros-nodes.sh

CMD bash -c "./wait-for-ros-nodes.sh"
