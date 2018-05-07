#!/bin/bash -e

# Verify that the RSU changes message transmit parameters when the RSU Immediate
# Forward Message (IFM) proxy configuration is altered

echo "Execute TP-RSU-MSG-BV-04"

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

echo "Xmit IFM MAP"
nc -u -w 1 ${SUT_IP} ${IFM_PORT} < map.conf

echo "Clear SNMP table"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.5.1.7.0 i 6

echo "Done TP-RSU-MSG-BV-04"
