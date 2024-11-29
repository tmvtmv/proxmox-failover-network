#!/bin/bash

# Check if an interface is provided as a parameter
if [ -z "$1" ]; then
    echo "Usage: $0 <interface>"
    exit 2
fi

INTERFACE="$1"
echo "Interface: ${INTERFACE}"

GATEWAY=`grep "routers" /var/lib/dhcp/dhclient.${INTERFACE}.leases | tail -1 | awk {'print $3'} | cut -f1 -d";" `
echo "Gateway: ${GATEWAY}"


# Perform the ping test
ping -I "$INTERFACE" -c 1 -W 1 ${GATEWAY} > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Default gateway ${GATEWAY} reachable"
    exit 0 # Gateway is reachable
else
    echo "Default gateway ${GATEWAY} unreachable"
    exit 1  # Gateway is unreachable
fi
