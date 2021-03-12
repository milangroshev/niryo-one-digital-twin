# ROS kinetic docker deployment to run ROS on Ubuntu16_04.
FROM ros:kinetic
MAINTAINER mgroshev@pa.uc3m.es

WORKDIR /root
RUN useradd -ms /bin/bash niryo

WORKDIR /home/niryo

CMD bash -c "source /opt/ros/kinetic/setup.bash && roscore"
