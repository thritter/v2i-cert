#!/bin/bash -e

# Verify that the RSU changes message transmit parameters when the RSU Immediate
# Forward Message (IFM) proxy configuration is altered

echo "Execute TP-RSU-MSG-BV-04"

TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source ${TOPDIR}/common.sh

#set -x

echo_ "Setup RSU Immediate Forward Message via SNMP"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.5.1.7.50 i 4

snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
  ${RSU_MIB}.5.1.2.50 x 8002 \
  ${RSU_MIB}.5.1.3.50 i 1 \
  ${RSU_MIB}.5.1.4.50 i 0 \
  ${RSU_MIB}.5.1.5.50 i 172 \
  ${RSU_MIB}.5.1.6.50 i 1

echo_ "Xmit IFM MAP"
set +e
nc -u -w 1 ${SUT_IP} ${IFM_PORT} < map.conf
set -e

echo_ "Clear SNMP table"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.5.1.7.50 i 6

echo_ "Done TP-RSU-MSG-BV-04"
