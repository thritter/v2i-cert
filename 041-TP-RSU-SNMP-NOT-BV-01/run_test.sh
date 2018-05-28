#!/bin/bash -e

# The roadside unit shall notify a remote host via SNMPv3 of its current NMEA GPGGA
# string at a configurable interval rsuGpsOutputInterval (OID 1.0.15628.4.1.8.4)
# You can use netcat for testing as a UDP server for example: sudo nc -6 -l -u -p ${OUT_PORT} -vvv

TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source ${TOPDIR}/common.sh

echo_ "Executing TP-RSU-SNMP-NOT-BV-01"
# set -x

snmpwalk ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.8

pause "Press Enter to configure GPS MIB"

OWN_IP=$(get_ipv6_from_netif_hex ${SUT_NETIF})
OWN_PORT=2080
RSU_INTERFACE=eth0

OUT_PORT=8888
OUT_ADDR="fe80000000000000025056fffe99bf09"
OUT_IFACE="eth0"

echo_ "Setting GPS output host with interval 1s"

snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
  ${RSU_MIB}.8.1.0 i ${OUT_PORT} \
  ${RSU_MIB}.8.2.0 x ${OUT_ADDR} \
  ${RSU_MIB}.8.3.0 s ${OUT_IFACE} \
  ${RSU_MIB}.8.4.0 i 1 \

echo_ "Check that SUT sends NMEA strings with 1s interval"
sleep 10

echo_ "Setting GPS output interval to 20s"

snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
  ${RSU_MIB}.8.4.0 i 20
  
echo_ "Check that SUT sends NMEA strings with 20s interval"
sleep 50

echo_ "Setting GPS output interval to 300s"

snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
  ${RSU_MIB}.8.4.0 i 300
  
echo_ "Check that SUT sends NMEA strings with 300s interval"
sleep 400

echo_ "TP-RSU-SNMP-NOT-BV-01 completed"
