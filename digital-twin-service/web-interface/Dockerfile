# ROS kinetic docker deployment to run ROS on Ubuntu16_04.
FROM ros:kinetic
MAINTAINER cmagalha@pa.uc3m.es

WORKDIR /root
RUN useradd -ms /bin/bash niryo

# Install system dependencies. 
RUN \
  apt-get update && \
  apt-get install -y lsof software-properties-common python-rosinstall python-rosinstall-generator python-wstool build-essential python-pip xauth ros-kinetic-robot-state-publisher ros-kinetic-moveit ros-kinetic-rosbridge-suite ros-kinetic-joy ros-kinetic-ros-control ros-kinetic-ros-controllers ros-kinetic-tf2-web-republisher ros-kinetic-joint-state-publisher-gui && \
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
    cd .. && bash -c "source /opt/ros/kinetic/setup.bash && catkin_make"

ADD ./web_interface/ .

# Run Web Interface
CMD bash -c "source /opt/ros/kinetic/setup.bash && source ~/catkin_ws/devel/setup.bash && ./start.sh"
