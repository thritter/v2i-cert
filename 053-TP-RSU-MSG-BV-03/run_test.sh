#!/bin/bash -e

# Verify that the RSU can convert inbound UDP frames to outbound SPAT messages
# with a delay not exceeding 50 milliseconds from the time the messages are received
# from an external host

echo "Execute TP-RSU-MSG-BV-03"

TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source ${TOPDIR}/common.sh

#set -x

echo "Setup RSU Immediate Forward Message via SNMP"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.5.1.7.0 i 4

snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
  ${RSU_MIB}.5.1.2.0 x 8002 \
  ${RSU_MIB}.5.1.3.0 i 1 \
  ${RSU_MIB}.5.1.4.0 i 0 \
  ${RSU_MIB}.5.1.5.0 i 172 \
  ${RSU_MIB}.5.1.6.0 i 1

echo "Xmit IFM SPAT"
nc -u -w 1 ${SUT_IP} ${IFM_PORT} < spat.conf

echo "Clear SNMP table"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.5.1.7.0 i 6

echo "Done TP-RSU-MSG-BV-03"
