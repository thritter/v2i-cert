#!/bin/bash -e

TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source ${TOPDIR}/common.sh

snmpwalk ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}

echo "Clear table"
snmpset ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}.7.1.11.0 i 6
