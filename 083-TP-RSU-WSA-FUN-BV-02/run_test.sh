#!/bin/bash -e

# Verify that RSU transmits WSA with Service Channel (SCH) Services based on the
# Store and Repeat Messages (SRM) contained in MIB OID 1.0.15628.4.1.4
# SRM services configured for the Control Channel (CCH), 178 are NOT included in the WSA

echo "Execute 083-TP-RSU-WSA-FUN-BV-02"

TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source ${TOPDIR}/common.sh

# set -x

DATE_START=$(date -u +'%Y%m%d%H%M' -d "+1 min")
DATE_END=$(date -u +'%Y%m%d%H%M' -d "+3 min")

echo "Install SRM1 PSID 8003 ID 1"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
    ${RSU_MIB}.4.1.2.0 x 8003 \
    ${RSU_MIB}.4.1.3.0 i 1 \
    ${RSU_MIB}.4.1.4.0 i 1 \
    ${RSU_MIB}.4.1.5.0 i 176 \
    ${RSU_MIB}.4.1.6.0 i 1000 \
    ${RSU_MIB}.4.1.7.0 x "${DATE_START}" \
    ${RSU_MIB}.4.1.8.0 x "${DATE_END}" \
    ${RSU_MIB}.4.1.9.0 x 001f4d2010000000000266bccdb082b28e6568c461045380342800002fc25445f0e030800200393205a200ba3174a062df5b290f93d901d05dc036e7ec066877d0c34eba16e3d408364010c189408840 \
    ${RSU_MIB}.4.1.10.0 i 1 \
    ${RSU_MIB}.4.1.11.0 i 4

echo "Install SRM1 PSID 8003 ID 2"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
    ${RSU_MIB}.4.1.2.1 x 8003 \
    ${RSU_MIB}.4.1.3.1 i 2 \
    ${RSU_MIB}.4.1.4.1 i 1 \
    ${RSU_MIB}.4.1.5.1 i 178 \
    ${RSU_MIB}.4.1.6.1 i 1000 \
    ${RSU_MIB}.4.1.7.1 x "${DATE_START}" \
    ${RSU_MIB}.4.1.8.1 x "${DATE_END}" \
    ${RSU_MIB}.4.1.9.1 x 001f4d2010000000000266bccdb082b28e6568c461045380342800002fc25445f0e030800200393205a200ba3174a062df5b290f93d901d05dc036e7ec066877d0c34eba16e3d408364010c189408840 \
    ${RSU_MIB}.4.1.10.1 i 1 \
    ${RSU_MIB}.4.1.11.1 i 4

echo "Tune channels 178 Alt, 176 Alt"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
    ${RSU_MIB}.12.1.3.0 i 1 \
    ${RSU_MIB}.12.1.4.0 i 178 \
    ${RSU_MIB}.12.1.5.0 i 176 \
    ${RSU_MIB}.12.1.6.0 i 4

echo "Waiting 1min"
sleep 60

echo "Check incoming WSAs"
sleep 60

echo "Clear SNMP table"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.4.1.11.0 i 6
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.4.1.11.1 i 6
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.12.1.6.0 i 6

echo "Done 082-TP-RSU-WSA-FUN-BV-02"
