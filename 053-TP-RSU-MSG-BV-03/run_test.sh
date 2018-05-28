#!/bin/bash -e

# Verify that the RSU can convert inbound UDP frames to outbound SPAT messages
# with a delay not exceeding 50 milliseconds from the time the messages are received
# from an external host

echo "Execute TP-RSU-MSG-BV-03"

TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source ${TOPDIR}/common.sh

#set -x

echo_ "Setup RSU Immediate Forward Message via SNMP"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.5.1.7.30 i 4

snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
  ${RSU_MIB}.5.1.2.30 x 8002 \
  ${RSU_MIB}.5.1.3.30 i 19 \
  ${RSU_MIB}.5.1.4.30 i 0 \
  ${RSU_MIB}.5.1.5.30 i 172 \
  ${RSU_MIB}.5.1.6.30 i 1

echo_ "Xmit IFM SPAT"
set +e
nc -u -w 1 ${SUT_IP} ${IFM_PORT} < spat.conf
set -e

echo_ "Clear SNMP table"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.5.1.7.30 i 6

echo_ "Done TP-RSU-MSG-BV-03"
