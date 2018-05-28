#!/bin/bash -e

# The roadside unit shall support Continuous Mode and Alternating Mode radio
# operations simultaneously

# Verify that RSU transmits WSA with Service Channel (SCH) Services based on the
# Store and Repeat Messages (SRM) contained in MIB OID 1.0.15628.4.1.4
# SRM services configured for the Control Channel (CCH), 178 are NOT included in the WSA

echo "Execute 061-TP-RSU-16094-MCTXRX-BV-01"

TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source ${TOPDIR}/common.sh

# set -x

DATE_START=$(set_date "+0 min")
DATE_END=$(set_date "+6 min")

echo_ "Install SRM1 PSID 8001 ID 1"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
    ${RSU_MIB}.4.1.2.3 x 8001 \
    ${RSU_MIB}.4.1.3.3 i 1 \
    ${RSU_MIB}.4.1.4.3 i 1 \
    ${RSU_MIB}.4.1.5.3 i 178 \
    ${RSU_MIB}.4.1.6.3 i 100 \
    ${RSU_MIB}.4.1.7.3 x "${DATE_START}" \
    ${RSU_MIB}.4.1.8.3 x "${DATE_END}" \
    ${RSU_MIB}.4.1.9.3 x 112233 \
    ${RSU_MIB}.4.1.10.3 i 1 \
    ${RSU_MIB}.4.1.11.3 i 4

echo_ "Install SRM1 PSID 8002 ID 2"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
    ${RSU_MIB}.4.1.2.1 x 8002 \
    ${RSU_MIB}.4.1.3.1 i 2 \
    ${RSU_MIB}.4.1.4.1 i 0 \
    ${RSU_MIB}.4.1.5.1 i 172 \
    ${RSU_MIB}.4.1.6.1 i 100 \
    ${RSU_MIB}.4.1.7.1 x "${DATE_START}" \
    ${RSU_MIB}.4.1.8.1 x "${DATE_END}" \
    ${RSU_MIB}.4.1.9.1 x 445566 \
    ${RSU_MIB}.4.1.10.1 i 1 \
    ${RSU_MIB}.4.1.11.1 i 4

echo_ "Install SRM1 PSID 8003 ID 3"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
    ${RSU_MIB}.4.1.2.2 x 8003 \
    ${RSU_MIB}.4.1.3.2 i 3 \
    ${RSU_MIB}.4.1.4.2 i 0 \
    ${RSU_MIB}.4.1.5.2 i 174 \
    ${RSU_MIB}.4.1.6.2 i 100 \
    ${RSU_MIB}.4.1.7.2 x "${DATE_START}" \
    ${RSU_MIB}.4.1.8.2 x "${DATE_END}" \
    ${RSU_MIB}.4.1.9.2 x 778899 \
    ${RSU_MIB}.4.1.10.2 i 1 \
    ${RSU_MIB}.4.1.11.2 i 4

echo_ "TODO: Modify WSMs for other channels!!!"
echo_ "Check incoming WSMs"
sleep_ 60

echo_ "Clear SNMP table"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.4.1.11.3 i 6
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.4.1.11.1 i 6
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.4.1.11.2 i 6

echo_ "Check incoming WSMs on the SUT??? step 11 is not clear..."
sleep_ 60

echo_ "TODO: Modify WSMs for other channels!!!"

echo_ "Done 061-TP-RSU-16094-MCTXRX-BV-01"
