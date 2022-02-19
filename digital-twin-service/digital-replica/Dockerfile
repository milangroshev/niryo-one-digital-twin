
# ROS kinetic docker deployment to run CoppeliaSim EDU on Ubuntu16_04 
# via subuser. 

FROM 10.9.8.105:5000/niryo-one-dtwin:2.0.0 
MAINTAINER jairomer@protonmail.com

USER root
WORKDIR /home/dtwin


COPY niryo-one-scene-4-boxes.simscene.xml .

ADD run_coppelia.sh /headless/Desktop/
RUN chmod +x /headless/Desktop/run_coppelia.sh

USER 1000

ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
CMD ["--wait"]

#CMD bash -c "source /opt/ros/kinetic/setup.bash && /home/dtwin/CoppeliaSim_Pro_V4_1_0_Ubuntu16_04/coppeliaSim.sh niryo-one-scene.simscene.xml"
