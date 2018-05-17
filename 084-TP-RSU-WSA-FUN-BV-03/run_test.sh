#!/bin/bash -e

# Verify that RSU transmits WSA with Service Channel (SCH) Services based on
# Immediate Forward Messages (IFM) received on non-DSRC interfaces as listed in MIB OID 1.0.15628.4.1.5
# IFM services configured for the Control Channel (CCH), 178 are NOT included in WSA

echo "Execute 084-TP-RSU-WSA-FUN-BV-03"

TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source ${TOPDIR}/common.sh

# set -x

echo "Install IFM1 PSID 8003"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
    ${RSU_MIB}.5.1.2.0 x 8003 \
    ${RSU_MIB}.5.1.3.0 i 1 \
    ${RSU_MIB}.5.1.4.0 i 1 \
    ${RSU_MIB}.5.1.5.0 i 176 \
    ${RSU_MIB}.5.1.6.0 i 1 \
    ${RSU_MIB}.5.1.7.0 i 4

echo "Install IFM2 PSID 8003"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
    ${RSU_MIB}.5.1.2.1 x 8003 \
    ${RSU_MIB}.5.1.3.1 i 2 \
    ${RSU_MIB}.5.1.4.1 i 1 \
    ${RSU_MIB}.5.1.5.1 i 178 \
    ${RSU_MIB}.5.1.5.1 i 1 \
    ${RSU_MIB}.5.1.7.1 i 4

echo "Tune channels 178 Alt, 176 Alt"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
    ${RSU_MIB}.12.1.3.0 i 1 \
    ${RSU_MIB}.12.1.4.0 i 178 \
    ${RSU_MIB}.12.1.5.0 i 176 \
    ${RSU_MIB}.12.1.6.0 i 4

echo "Verify incoming WSAs"
sleep 120

echo "Clear SNMP table"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.5.1.7.0 i 6
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.5.1.7.1 i 6
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.12.1.6.0 i 6

echo "Done 084-TP-RSU-WSA-FUN-BV-03"