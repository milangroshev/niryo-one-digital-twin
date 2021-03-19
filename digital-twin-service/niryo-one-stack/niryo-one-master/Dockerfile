# ROS kinetic docker deployment to run ROS on Ubuntu16_04.
FROM ros:melodic
MAINTAINER mgroshev@pa.uc3m.es

WORKDIR /root
RUN useradd -ms /bin/bash niryo

USER niryo
WORKDIR /home/niryo

CMD bash -c "source /opt/ros/melodic/setup.bash && roscore"
