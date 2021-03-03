!#/bin/bash

sudo docker network create -d macvlan -o parent=enp0s3 --subnet 10.0.2.0/24 --ip-range 10.0.2.192/27 --aux-address 'host=10.0.2.223' robot_eth_macvlan

sleep 1

sudo ip link add mynet-shim link enp0s3 type macvlan  mode bridge

sleep 1

sudo ip addr add 10.0.2.223/32 dev mynet-shim

sleep 1

sudo ip link set mynet-shim up

sleep 1

sudo ip route add 10.0.2.192/27 dev mynet-shim
