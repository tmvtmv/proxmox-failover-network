#!/bin/bash
# Check if an interface is provided as a parameter
if [ -z "$1" ]; then
  echo "Usage: $0 <interface>"
  exit 2
fi

INTERFACE="$1"
GATEWAY=`grep "routers" /var/lib/dhcp/dhclient.${INTERFACE}.leases | tail -1 | awk {'print $3'} | cut -f1 -d";" `
echo "Interface ${INTERFACE} has ${GATEWAY} as gateway."

ip route del default 2>/dev/null
ip route add default via ${GATEWAY} dev ${INTERFACE}

echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -F

if [ "${INTERFACE}" == "ens192" ]; then
  iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -o ens192 -j MASQUERADE
else
  iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -o ens160 -j MASQUERADE
fi
