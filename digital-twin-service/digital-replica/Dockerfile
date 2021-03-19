
# ROS kinetic docker deployment to run CoppeliaSim EDU on Ubuntu16_04 
# via subuser. 

FROM ubuntu:16.04
MAINTAINER jairomer@protonmail.com

WORKDIR /root
RUN useradd -ms /bin/bash dtwin

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
  apt-get install -y build-essential sudo -qqy x11-apps && \
  apt-get install -y software-properties-common && \
  apt-get install -y byobu curl git htop man unzip vim wget && \
  apt-get install -y ros-kinetic-desktop-full && \
  apt-get install -y python-rosinstall python-rosinstall-generator && \
  apt-get install -y python-wstool build-essential python3-pip xauth && \
  apt-get install -y qt5-default &&\
  pip3 install jsonpickle && \
  rm -rf /var/lib/apt/lists/*

RUN pip3 install -U catkin_tools

# Initialize rosdep. 
# "rosdep" enables you to easily install system dependencies for source you want 
# to compile and is required to run some core components in ROS. 
RUN rosdep init

USER dtwin
WORKDIR /home/dtwin

RUN rosdep update && mkdir -p catkin_ws/src && cd catkin_ws && catkin init && cd ..

COPY niryo-one-scene.simscene.xml .

# Download CoppeliaSim
RUN wget https://www.coppeliarobotics.com/files/CoppeliaSim_Pro_V4_1_0_Ubuntu16_04.tar.xz && tar xvvf CoppeliaSim_Pro_V4_1_0_Ubuntu16_04.tar.xz 

COPY Niryo-One-Replay.ttm CoppeliaSim_Pro_V4_1_0_Ubuntu16_04/models/robots/non-mobile/ 

USER root

## Connection ports for controlling the UI:
# VNC port:5901
# noVNC webport, connect via http://IP:6901/?password=vncpassword
ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    NO_VNC_PORT=6901

### Envrionment config
ENV HOME=/headless \
    TERM=xterm \
    STARTUPDIR=/dockerstartup \
    INST_SCRIPTS=/headless/install \
    NO_VNC_HOME=/headless/noVNC \
    DEBIAN_FRONTEND=noninteractive \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1280x1024 \
    VNC_PW=netcom; \
    VNC_VIEW_ONLY=false
WORKDIR $HOME

### Add all install scripts for further steps
ADD ./VNCconf/install/ $INST_SCRIPTS/
RUN find $INST_SCRIPTS -name '*.sh' -exec chmod a+x {} +

### Install some common tools
RUN $INST_SCRIPTS/tools.sh
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

### Install custom fonts
RUN $INST_SCRIPTS/install_custom_fonts.sh

### Install xvnc-server & noVNC - HTML5 based VNC viewer
RUN $INST_SCRIPTS/tigervnc.sh
RUN $INST_SCRIPTS/no_vnc.sh

### Install firefox and chrome browser
RUN $INST_SCRIPTS/firefox.sh
RUN $INST_SCRIPTS/chrome.sh

### Install xfce UI
RUN $INST_SCRIPTS/xfce_ui.sh
ADD ./VNCconf/xfce/ $HOME/


### configure startup
RUN $INST_SCRIPTS/libnss_wrapper.sh
ADD ./VNCconf/scripts $STARTUPDIR
RUN $INST_SCRIPTS/set_user_permission.sh $STARTUPDIR $HOME
ADD run_coppelia.sh /headless/Desktop/
RUN chmod +x /headless/Desktop/run_coppelia.sh
#if ERROR: Compiled with the flag for AVX but not supported by the CPU.
RUN rm /home/dtwin/CoppeliaSim_Pro_V4_1_0_Ubuntu16_04/libsimExtDynamicsVortex.so

USER 1000

ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
CMD ["--wait"]

#CMD bash -c "source /opt/ros/kinetic/setup.bash && /home/dtwin/CoppeliaSim_Pro_V4_1_0_Ubuntu16_04/coppeliaSim.sh niryo-one-scene.simscene.xml"
