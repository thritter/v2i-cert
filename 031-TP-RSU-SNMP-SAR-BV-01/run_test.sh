#!/bin/bash -e

# The roadside unit shall allow authorized users to add/remove Messages from the Active
# Message directory through SNMPv3 rsuSRMStatusTable (OID 1.0.15628.4.1.4)
# The roadside unit SHALL allow authorized users to view the contents of Active
# Messages in the Active Message directory through SNMPv3 rsuSRMStatusTable (OID 1.0.15628.4.1.4)
# The roadside unit SHALL allow authorized users to modify an Active Message in the
# SNMPv3 rsuSRMStatusTable (OID 1.0.15628.4.1.4)

TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source ${TOPDIR}/common.sh

echo_ "Executing TP-RSU-SNMP-SAR-BV-01"

#DATE_START=$(date -u +'%Y%m%d%H%M' -d "+1 minute")
#DATE_END=$(date -u +'%Y%m%d%H%M' -d "+3 minute")
DATE_START=$(set_date "+1 minute") 
DATE_END=$(set_date "+3 minute")

echo_ "Install SRM1 from ${DATE_START} till ${DATE_END}"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.4.1.11.1 i 4
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
  ${RSU_MIB}.4.1.2.1 x 8003 \
  ${RSU_MIB}.4.1.3.1 i 31 \
  ${RSU_MIB}.4.1.4.1 i 1 \
  ${RSU_MIB}.4.1.5.1 i 178 \
  ${RSU_MIB}.4.1.6.1 i 1000 \
  ${RSU_MIB}.4.1.9.1 x 001f4d2010000000000266bccdb082b28e6568c461045380342800002fc25445f0e030800200393205a200ba3174a062df5b290f93d901d05dc036e7ec066877d0c34eba16e3d408364010c189408840 \
  ${RSU_MIB}.4.1.7.1 x "${DATE_START}" \
  ${RSU_MIB}.4.1.8.1 x "${DATE_END}"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.4.1.10.1 i 1

DATE_START=$(set_date "+1 minute") 
DATE_END=$(set_date "+4 minute")
echo_ "Install SRM2 from ${DATE_START} till ${DATE_END}"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.4.1.11.2 i 4
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
  ${RSU_MIB}.4.1.2.2 x 8003 \
  ${RSU_MIB}.4.1.3.2 i 31 \
  ${RSU_MIB}.4.1.4.2 i 1 \
  ${RSU_MIB}.4.1.5.2 i 178 \
  ${RSU_MIB}.4.1.6.2 i 1000 \
  ${RSU_MIB}.4.1.9.2 x 001f4d20100000000002067c0ab080f2936af80c4a4294fc27bc0700cfc400001f4000007e526d5f018948529f84f780b72038000015f1d24794b077ccdfe0020fd665631e5e5d34e6d38f0f4d3bf700 \
  ${RSU_MIB}.4.1.7.2 x "${DATE_START}" \
  ${RSU_MIB}.4.1.8.2 x "${DATE_END}"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.4.1.10.2 i 1
pause "Started SRM1 and SRM2 transmissions - Press return to continue"  

snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.4.1.10.1 i 0
pause "Stopped SRM1 transmissions - Press return to continue"  

DATE_START=$(set_date "+2 minute") 
DATE_END=$(set_date "+5 minute")
echo_ "Modified SRM1 from ${DATE_START} till ${DATE_END}"
#snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.4.1.11.1 i 4
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
  ${RSU_MIB}.4.1.7.1 x "${DATE_START}" \
  ${RSU_MIB}.4.1.8.1 x "${DATE_END}"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.4.1.10.1 i 1

pause "Started SRM1 and SRM2 transmissions - Press return to continue"  

snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.4.1.11.2 i 6
snmpwalk ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.4
pause "Deleted SRM2. SRM1 still transmitted - Press return to continue"  

snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.4.1.11.1 i 6
echo_ "Deleted SRM1"  

echo_ "TP-RSU-SNMP-SAR-BV-01 completed"