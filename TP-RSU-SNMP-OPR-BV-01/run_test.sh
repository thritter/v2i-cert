#!/bin/bash -e

echo "Execute TP-RSU-SNMP-OPR-BV-01"

#set -x
TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source ${TOPDIR}/common.sh

echo "Populate tables"
snmpset ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}.4.1.11.0 i 4
snmpset ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}.5.1.7.0 i 4
snmpset ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}.7.1.11.0 i 4
snmpset ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}.13.1.8.0 i 4


echo "Walk tree"
snmpwalk ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}


echo "Clear tables"
snmpset ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}.4.1.11.0 i 6
snmpset ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}.5.1.7.0 i 6
snmpset ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}.7.1.11.0 i 6
snmpset ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}.13.1.8.0 i 6

echo "TP-RSU-SNMP-OPR-BV-01 succeeded"
