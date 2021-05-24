FROM ros:noetic

RUN apt-get -y update && apt-get -y install python3-pip python3-rospy
RUN pip3 install eclipse-zenoh==0.5.0-b5 flask
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

WORKDIR /root
COPY pub-robot-data.py .  
COPY zenoh-replay.py .
COPY runner.sh .

ENV ZENOH_ROUTER_ADDRESS tcp/10.0.2.199:7447
ENV DIGITAL_TWIN_ROS_TOPIC /coppeliaSIM/NiryoOne/joint_states
ENV REPLICA_ROS_TOPIC /coppeliaSIM/NiryoOne/joint_states
ENV REPLICA_HZ 15 
ENV ROS_MASTER_URI http://10.0.2.193:11311/
ENV REPLAY_DURATION 25 

CMD echo $ZENOH_ROUTER_ADDRESS
CMD ./runner.sh
CMD sleep infinity
# CMD python3 pub-robot-data.py $ZENOH_ROUTER_ADDRESS $DIGITAL_TWIN_ROS_TOPIC &
# CMD python3 zenoh-replay.py $ZENOH_ROUTER_ADDRESS $REPLICA_ROS_TOPIC 15 
