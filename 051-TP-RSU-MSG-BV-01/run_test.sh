#!/bin/bash -e

# Verify that the RSU transmits MAP messages (i.e. MessageFrame containing
# MSG_MapData per [11]) according to the specified Time instructions

echo "Execute TP-RSU-MSG-BV-01"

#set -x

DATE_START=$(date -u +'%m/%d/%Y, %H:%M')
DATE_END=$(date -u +'%m/%d/%Y, %H:%M' -d "+2 min")

TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source ${TOPDIR}/common.sh

echo "Setup RSU Immediate Forward Message via SNMP"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.5.1.7.0 i 4

snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
  ${RSU_MIB}.5.1.2.0 x 8002 \
  ${RSU_MIB}.5.1.3.0 i 1 \
  ${RSU_MIB}.5.1.4.0 i 0 \
  ${RSU_MIB}.5.1.5.0 i 172 \
  ${RSU_MIB}.5.1.6.0 i 1

echo "Xmit MAP"
sed -e "s+%DATE_START%+${DATE_START}+" -e "s+%DATE_END%+${DATE_END}+" map.conf > my_map_xmit.txt
nc -u -w 1 ${SUT_IP} ${IFM_PORT} < my_map_xmit.txt

sleep 180

echo "Clear SNMP table"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.5.1.7.0 i 6

echo "Done TP-RSU-MSG-BV-01"
