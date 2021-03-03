
sudo docker run \
    --hostname replay \
    -it \
    --rm \
    --net=robot_eth_macvlan \
    --ip=10.0.2.200 \
    -p 5000:5000 \
    -e ROS_IP=10.0.2.200 \
    -e REPLICA_ROS_TOPIC=/coppeliaSIM/NiryoOne1/joint_states1 \
    --add-host dtwin:127.0.0.1 \
    --add-host niryo-one-control:10.0.2.194 \
    --add-host niryo-one-motion:10.0.2.195 \
    --add-host niryo-one-interface:10.0.2.196 \
    --add-host niryo-one-sim:10.0.2.193 \
    --add-host dtwin-web:10.0.2.198 \
    --add-host dtwin:10.0.2.197 \
    zenoh-replay:latest \
#    bash
#--user root \

