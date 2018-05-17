#!/bin/bash -e

# The roadside unit shall support Continuous Mode and Alternating Mode radio
# operations simultaneously

#!/bin/bash -e

# Verify that RSU transmits WSA with Service Channel (SCH) Services based on the
# Store and Repeat Messages (SRM) contained in MIB OID 1.0.15628.4.1.4
# SRM services configured for the Control Channel (CCH), 178 are NOT included in the WSA

echo "Execute 061-TP-RSU-16094-MCTXRX-BV-01"

TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source ${TOPDIR}/common.sh

# set -x

DATE_START=$(date -u +'%Y%m%d%H%M' -d "+0 min")
DATE_END=$(date -u +'%Y%m%d%H%M' -d "+6 min")

echo "Install SRM1 PSID 8001 ID 1"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
    ${RSU_MIB}.4.1.2.0 x 8001 \
    ${RSU_MIB}.4.1.3.0 i 1 \
    ${RSU_MIB}.4.1.4.0 i 1 \
    ${RSU_MIB}.4.1.5.0 i 178 \
    ${RSU_MIB}.4.1.6.0 i 100 \
    ${RSU_MIB}.4.1.7.0 x "${DATE_START}" \
    ${RSU_MIB}.4.1.8.0 x "${DATE_END}" \
    ${RSU_MIB}.4.1.9.0 x 112233 \
    ${RSU_MIB}.4.1.10.0 i 1 \
    ${RSU_MIB}.4.1.11.0 i 4

echo "Install SRM1 PSID 8002 ID 2"
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

echo "Install SRM1 PSID 8003 ID 3"
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

echo "TODO: Modify WSMs for other channels!!!"
echo "Check incoming WSMs"
sleep 60

echo "Clear SNMP table"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.4.1.11.0 i 6
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.4.1.11.1 i 6
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.4.1.11.2 i 6

echo "Check incoming WSMs on the SUT??? step 11 is not clear..."
sleep 60

echo "TODO: Modify WSMs for other channels!!!"

echo "Done 061-TP-RSU-16094-MCTXRX-BV-01"
