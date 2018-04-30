#!/bin/bash -e

#set -x
source common.sh

snmpget ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}.1.17.4.0

RESULT=$(snmpget ${RW_AUTH_ARGS} ${SUT_IP} -Oqv ${RSU_MIB}.1.17.4.0)
echo "Read RSU ID ${RSU_MIB}.1.17.4.0: ${RESULT}"

echo "Write RSU ID"
snmpset ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}.1.17.4.0 s 'RSU-Cert'

echo "Read RSU ID"
snmpget ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}.1.17.4.0
