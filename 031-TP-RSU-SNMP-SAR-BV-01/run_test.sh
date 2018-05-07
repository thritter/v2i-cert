#!/bin/bash -e

# The roadside unit shall allow authorized users to add/remove Messages from the Active
# Message directory through SNMPv3 rsuSRMStatusTable (OID 1.0.15628.4.1.4)
# The roadside unit SHALL allow authorized users to view the contents of Active
# Messages in the Active Message directory through SNMPv3 rsuSRMStatusTable (OID 1.0.15628.4.1.4)
# The roadside unit SHALL allow authorized users to modify an Active Message in the
# SNMPv3 rsuSRMStatusTable (OID 1.0.15628.4.1.4)

TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source ${TOPDIR}/common.sh

DATE_START=$(date -u +'%Y%m%d%H%M')
DATE_END=$(date -u +'%Y%m%d%H%M' -d "+1 hour")

echo "Install SRM from ${DATE_START} till ${DATE_END}"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.4.1.11.0 i 4
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
  ${RSU_MIB}.4.1.2.0 x 8003 \
  ${RSU_MIB}.4.1.3.0 i 1 \
  ${RSU_MIB}.4.1.4.0 i 1 \
  ${RSU_MIB}.4.1.5.0 i 178 \
  ${RSU_MIB}.4.1.6.0 i 1 \
  ${RSU_MIB}.4.1.9.0 x 001f4d2010000000000266bccdb082b28e6568c461045380342800002fc25445f0e030800200393205a200ba3174a062df5b290f93d901d05dc036e7ec066877d0c34eba16e3d408364010c189408840 \

snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
  ${RSU_MIB}.4.1.7.0 x "${DATE_START}" \
  ${RSU_MIB}.4.1.8.0 x "${DATE_END}" \
  ${RSU_MIB}.4.1.10.0 i 1

echo "Start WSM transmission now - Press return to stop"
read a

echo "Clear table"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.4.1.11.0 i 6
