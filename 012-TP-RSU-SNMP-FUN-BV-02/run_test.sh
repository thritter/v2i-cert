#!/bin/bash -e

# Verify that the roadside unit shall send the GPGGA NMEA String to a specified UDP
# port at a specified rate, upon acquisition of 3 or more Satellites, as configured in
# SNMPv3 MIB OID 1.0.15628.4.1.8.

#set -x
TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source ${TOPDIR}/common.sh

echo_ "Executing TP-RSU-SNMP-FUN-BV-02"

snmpwalk ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.8

pause "Press Enter to configure GPS MIB"

OWN_IP=$(get_ipv6_from_netif_hex ${SUT_NETIF})
OWN_PORT=2080
RSU_INTERFACE=eth0

snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
 ${RSU_MIB}.8.1.0 i ${OWN_PORT} \
 ${RSU_MIB}.8.2.0 x ${OWN_IP} \
 ${RSU_MIB}.8.3.0 s ${RSU_INTERFACE} \
 ${RSU_MIB}.8.4.0 i 60 

set +e 
sudo nc -6 -kluv -p ${OWN_PORT}
set -e

echo_ "TP-RSU-SNMP-FUN-BV-02 completed"
