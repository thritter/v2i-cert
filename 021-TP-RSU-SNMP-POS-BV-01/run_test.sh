#!/bin/bash -e

# The roadside unit shall notify a remote host via SNMPv3 if its GPS position deviates
# from the stored reference by more than a configurable radius (OID 1.0.15628.4.1.100.0.11)

echo "Execute TP-RSU-SNMP-OPR-BV-01"


#set -x
TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source ${TOPDIR}/common.sh

echo "Populate tables"
snmpset ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}.4.1.11.0 i 4
snmpset ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}.5.1.7.0 i 4
snmpset ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}.7.1.11.0 i 4
snmpset ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}.13.1.8.0 i 4


echo "Walk tree IP MIB"
snmpwalk ${RW_AUTH_ARGS} ${SUT_IP} ${MGMT_MIB_2}.4

echo "Walk tree RSU"
snmpwalk ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}


echo "Clear tables"
snmpset ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}.4.1.11.0 i 6
snmpset ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}.5.1.7.0 i 6
snmpset ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}.7.1.11.0 i 6
snmpset ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}.13.1.8.0 i 6

echo "TP-RSU-SNMP-OPR-BV-01 succeeded"
