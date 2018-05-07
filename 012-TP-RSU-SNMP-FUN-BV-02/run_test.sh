#!/bin/bash -e

# Verify that the roadside unit shall send the GPGGA NMEA String to a specified UDP
# port at a specified rate, upon acquisition of 3 or more Satellites, as configured in
# SNMPv3 MIB OID 1.0.15628.4.1.8.

echo "Execute TP-RSU-SNMP-FUN-BV-02"

#set -x
TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source ${TOPDIR}/common.sh

OWN_IP=$(get_ipv6_from_netif_hex ${SUT_NETIF})
OWN_PORT=2080

echo "Install forward PSID=32 to ${OWN_IP}"

snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
 ${RSU_MIB}.8.1.0 i ${OWN_PORT} \
 ${RSU_MIB}.8.2.0 x ${OWN_IP} \
 ${RSU_MIB}.8.3.0 s eth0 \
 ${RSU_MIB}.8.4.0 i 5

#sudo nc -6 -kluv -p ${OWN_PORT}

echo "TP-RSU-SNMP-FUN-BV-02 succeeded"
