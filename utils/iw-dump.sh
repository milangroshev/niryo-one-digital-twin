#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Usage: <interface name> <file>"
    exit 1
fi

IFACE=$1
FILE=$2

echo "inactive (ms),rx_bytes,rx_packets,tx_bytes,tx_packets,tx_retries,tx_failed,rx_drop_misc,signal,signal_average,tx_bitrate,rx_bitrate,associated" > $FILE

while true; do
        #get all the stations connected to the AP
        stat=$(iw dev $IFACE station dump)
        IFS=' ' read -r -a sts_array <<< "$sts"
        num=${#array[@]}

        for element in $num
        do
            echo $element
            #get the inactive time parameter
            inactive=$( echo "$stat" | grep 'inactive time' | cut -d':' -f2 | xargs )
            inactive1=${inactive// ms/,}
            IFS=', ' read -r -a intact_array <<< "$inactive1"

            #get the rx bytes parameter
            rx_bytes=$( echo "$stat" | grep 'rx bytes' | cut -d':' -f2 | xargs )
            IFS=' ' read -r -a rxb_array <<< "$rx_bytes"

            #get the rx packets parameter
            rx_packets=$( echo "$stat" | grep 'rx packets' | cut -d':' -f2 | xargs )
            IFS=' ' read -r -a rxp_array <<< "$rx_packets"

            #get the tx bytes parameter
            tx_bytes=$( echo "$stat" | grep 'tx bytes' | cut -d':' -f2 | xargs )
            IFS=' ' read -r -a txb_array <<< "$tx_bytes"

            #get the tx packets parameter
            tx_packets=$( echo "$stat" | grep 'tx packets' | cut -d':' -f2 | xargs )
            IFS=' ' read -r -a txp_array <<< "$tx_packets"

            #get the tx retries parameter
            tx_retries=$( echo "$stat" | grep 'tx retries' | cut -d':' -f2 | xargs )
            IFS=' ' read -r -a txr_array <<< "$tx_retries"

            #get the tx failed parameter
            tx_failed=$( echo "$stat" | grep 'tx failed' | cut -d':' -f2 | xargs )
            IFS=' ' read -r -a txf_array <<< "$tx_failed"

            #get the rx drop misc parameter
            rx_drop_misc=$( echo "$stat" | grep 'rx drop misc' | cut -d':' -f2 | xargs )
            IFS=' ' read -r -a rxdm_array <<< "$rx_drop_misc"

            #get the signal parameter
            signal=$( echo "$stat" | grep 'signal:' | cut -d':' -f2 | xargs )
            signal1=${signal// dBm/,}
            IFS=',' read -r -a s_array <<< "$signal1"

            #get the signal avg parameter
            signal_avg=$( echo "$stat" | grep 'signal avg:' | cut -d':' -f2 | xargs )
            signal_avg1=${signal_avg// dBm/,}
            IFS=',' read -r -a savg_array <<< "$signal_avg1"

            #get the tx bitrate parameter
            tx_bitrate=$( echo "$stat" | grep 'tx bitrate' | cut -d':' -f2 | xargs )
            tx_bitrate1=${tx_bitrate// MCS 7/,}
            IFS=',' read -r -a txbrate_array <<< "$tx_bitrate1"

            #get the rx bitrate parameter
            rx_bitrate=$( echo "$stat" | grep 'rx bitrate' | cut -d':' -f2 | xargs )
            rx_bitrate1=${rx_bitrate// MCS 7/,}
            IFS=',' read -r -a rxbrate_array <<< "$rx_bitrate1"

            #get the associated parameter
            associated=$( echo "$stat" | grep 'associated' | cut -d':' -f2 | xargs )
            IFS=' ' read -r -a a_array <<< "$associated"

            echo "${intact_array[$num]},${rxb_array[$num]},${rxp_array[$num]},${txb_array[$num]},${txp_array[$num]},${txr_array[$num]},${txf_array[$num]},${rxdm_array[$num]},${s_array[$num]},${savg_array[$num]},${txbrate_array[$num]},${rxbrate_array[$num]},${a_array[$num]}" >> $FILE
        done

        sleep 1

done
