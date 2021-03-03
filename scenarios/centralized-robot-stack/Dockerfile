# ROS kinetic docker deployment to run ROS on Ubuntu16_04.
FROM ubuntu:16.04
MAINTAINER cmagalha@pa.uc3m.es

WORKDIR /root
RUN useradd -ms /bin/bash niryo-one-sim

# Setup ROS dependencies. 
RUN \
  apt-get update && \
  apt-get install -y software-properties-common && \
  sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
  apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# Install system dependencies. 
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  add-apt-repository universe && \
  add-apt-repository multiverse && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y ros-kinetic-desktop-full && \
  apt-get install -y python-rosinstall python-rosinstall-generator && \
  apt-get install -y python-wstool build-essential python-pip xauth && \
  apt-get install -y ros-kinetic-robot-state-publisher \
    ros-kinetic-moveit ros-kinetic-rosbridge-suite ros-kinetic-joy \
    ros-kinetic-ros-control ros-kinetic-ros-controllers \
    ros-kinetic-tf2-web-republisher ros-kinetic-joint-state-publisher-gui &&\
  pip install jsonpickle && \
  rm -rf /var/lib/apt/lists/*

RUN rosdep init

#RUN wget https://sourceforge.net/projects/ptpd/files/ptpd/2.3.1/ptpd-2.3.1.tar.gz && \
#	cp ptpd-2.3.1.tar.gz /opt && \
#	cd /opt && \
#	tar xvzf ptpd-2.3.1.tar.gz && rm ptpd-2.3.1.tar.gz && mv /opt/ptpd-2.3.1 /opt/ptpd && \
#	cd /opt/ptpd && sudo ./configure && make && make install

USER niryo-one-sim
WORKDIR /home/niryo-one-sim

RUN rosdep update && \
    mkdir -p catkin_ws/src && cd catkin_ws/src && \
    git clone https://github.com/NiryoRobotics/niryo_one_ros.git .

RUN cd catkin_ws && bash -c "source /opt/ros/kinetic/setup.bash && catkin_make"

CMD bash -c "source /opt/ros/kinetic/setup.bash && source catkin_ws/devel/setup.bash && roslaunch niryo_one_bringup desktop_rviz_simulation.launch"
