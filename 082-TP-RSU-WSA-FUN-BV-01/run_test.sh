#!/bin/bash -e

# Verify that RSU system clock conforms to the UTC timing standard

echo "Execute 082-TP-RSU-WSA-FUN-BV-01"

TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source ${TOPDIR}/common.sh

# set -x


echo "Install WSA1 PSID 8003"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
    ${RSU_MIB}.13.1.2.0 x 8003 \
    ${RSU_MIB}.13.1.3.0 i 0 \
    ${RSU_MIB}.13.1.4.0 s "1234" \
    ${RSU_MIB}.13.1.5.0 x 00000000000000000000000000000002 \
    ${RSU_MIB}.13.1.6.0 i 1024 \
    ${RSU_MIB}.13.1.7.0 i 176 \
    ${RSU_MIB}.13.1.8.0 i 4

 echo "Install WSA2 PSID EFFFFFFF"
 snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
    ${RSU_MIB}.13.1.2.1 x EFFFFFFF \
    ${RSU_MIB}.13.1.3.1 i 0 \
    ${RSU_MIB}.13.1.4.1 s "5678" \
    ${RSU_MIB}.13.1.5.1 x 00000000000000000000000000000002 \
    ${RSU_MIB}.13.1.6.1 i 1025 \
    ${RSU_MIB}.13.1.7.1 i 176 \
    ${RSU_MIB}.13.1.8.1 i 4

echo "Verify incoming WSAs"
sleep 120

echo "Clear SNMP table"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.13.1.8.0 i 6
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.13.1.8.1 i 6

echo "Done 082-TP-RSU-WSA-FUN-BV-01"