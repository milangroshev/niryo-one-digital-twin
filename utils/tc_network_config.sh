#!/bin/bash

INT_NAME="eno1"
LATENCY="20ms"
LOSS="10%"

echo ""
answer=""

while [[ ! $answer =~ ^[YyNn]$ ]]; do
    echo ">> Please verify that the following parameters are configured properly!"
    echo "+++++++++++++++++++++++++++++++++++++++++"
    echo "+ Phisical network interface name: $INT_NAME +" 
    echo "+ Latency: $LATENCY                         +"
    echo "+ Packet loss: $LOSS                      +"    
    echo "+++++++++++++++++++++++++++++++++++++++++"
    echo -n ">> Do you want to proceede? (y/n)? "
    read answer
done

if [[ $answer =~ ^[Nn]$ ]]; then
    exit 1
fi

echo ">> Creating virtual interface ifb for ingress traffic"
modprobe ifb numifbs=1
sleep 1
echo ">> Enabling ifb"
ip link set dev ifb0 up
sleep 1
echo ">> Redirecting ingress traffic from $INT_NAME to ifb"
tc qdisc add dev $INT_NAME ingress
sleep 1
tc filter add dev $INT_NAME parent ffff: protocol ip u32 match u32 0 0 flowid 1:1 action mirred egress redirect dev ifb0


while :
do

    while [[ ! $answer =~ ^[123]$ ]]; do
        echo "+++++++++++++++++++++++++++++++++++++++++"
        echo "+ 1. Fix latency                        +" 
        echo "+ 2. Packet loss                        +"
        echo "+ 3. Exit                               +"    
        echo "+++++++++++++++++++++++++++++++++++++++++"
        echo -n ">> Select the rule type (1/2/3) "
        read answer
    done

    if [[ $answer =~ ^[1]$ ]]; then
        echo ""
        answer=""

        while [[ ! $answer =~ ^[1234567890]$ ]]; do 
            echo -n ">> Set latency value: (ms)? "
            read LATENCY
            LATENCY="${LATENCY}ms"
        done

        while [[ ! $answer =~ ^[IiEe]$ ]]; do 
            echo -n ">> Do you want to add ingress or egress rules (i/e)? "
            read answer
        done

        if [[ $answer =~ ^[Ii]$ ]]; then
            echo ">> Adding fix latency of $LATENCY to all the ingress traffic on interface $INT_NAME"
            tc qdisc del dev ifb0 root netem
            sleep 1
	        tc qdisc add dev ifb0 root netem delay $LATENCY
            sleep 1
        fi

        if [[ $answer =~ ^[Ee]$ ]]; then
            echo ">> Adding fix latency of $LATENCY to all the egress traffic on interface $INT_NAME"
	        tc qdisc del dev $INT_NAME root
            sleep 1
            tc qdisc add dev $INT_NAME root netem delay $LATENCY
            sleep 1
        fi
    fi

    if [[ $answer =~ ^[2]$ ]]; then
        echo ""
        answer=""

        while [[ ! $answer =~ ^[IiEe]$ ]]; do 
            echo -n ">> Do you want to add ingress or egress rules (i/e)? "
            read answer
        done

        if [[ $answer =~ ^[Ii]$ ]]; then
            echo ">> Adding fix packet loss of $LOSS to all the ingress traffic on interface $INT_NAME"
            tc qdisc del dev ifb0 root netem
            sleep 1
	        tc qdisc add dev ifb0 root netem loss $LOSS
	        sleep 1
        fi

        if [[ $answer =~ ^[Ee]$ ]]; then
            echo ">> Adding fix latency of $LATENCY to all the eggress traffic on interface $INT_NAME"
            tc qdisc del dev $INT_NAME root
            sleep 1
	        tc qdisc add dev $INT_NAME root netem delay $LATENCY
            sleep 1
        fi
    fi

    if [[ $answer =~ ^[3]$ ]]; then
        echo ">> Deleting ingress and eggress rules"
        tc qdisc del dev ifb0 root netem
        tc qdisc del dev $INT_NAME root
        echo ">> Removing virtual interface ibf"
        tc qdisc del dev $INT_NAME handle ffff: ingress
        sleep 1
        modprobe -r ifb
        sleep 1
        exit 1
    fi
done
