#!/bin/bash


LIMIT_MODE=$1
GB_LIMIT=$2

if ! [[ $LIMIT_MODE =~ ^(IN|OUT|TOTAL)$ ]]; then
	echo "First argument (LIMIT_MODE) must be one of these: IN|OUT|TOTAL"
	exit
fi

if ! [[ $GB_LIMIT =~ ^[0-9]+$ ]]; then
	echo "Second argument (GB_LIMIT) must be an integer!"
	exit
fi


IFACE="eth0"

## Receive/download TO this server - inbound in MiB
total_rx=$(vnstat --dumpdb -i $IFACE | grep 'totalrx;' | cut -d';' -f2)

## Transmit/upload FROM this server - outbound in MiB
total_tx=$(vnstat --dumpdb -i $IFACE | grep 'totaltx;' | cut -d';' -f2)


## 1 gigabyte = ~954 "mebibytes"
gb_in=$(echo "$total_rx / 954" | bc)
gb_out=$(echo "$total_tx / 954" | bc)

total=$(( $gb_in + $gb_out ))


echo "GB_IN (download): $gb_in"
echo "GB_OUT (upload): $gb_out"
echo "GB_TOTAL: $total"
echo "GB_LIMIT: $GB_LIMIT"

echo ""

# how many GB of data are actually relevant to us - GB_OUT is free on some hosting providers
GB_TOTAL=0
if [[ $LIMIT_MODE = "IN" ]]; then
	GB_TOTAL=$gb_in
elif [[ $LIMIT_MODE = "OUT" ]]; then
	GB_TOTAL=$gb_out
else
	GB_TOTAL=$(( $gb_in + $gb_out ))
fi


if [ "$GB_TOTAL" -ge "$GB_LIMIT" ]; then
	echo "Status: OVER the limit by $(( $GB_TOTAL - $GB_LIMIT )) GB"
	
	eval $3
else
	echo "Status: UNDER the limit by $(( $GB_LIMIT - $GB_TOTAL )) GB"
fi


