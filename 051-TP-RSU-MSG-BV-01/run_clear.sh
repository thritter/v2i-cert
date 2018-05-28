#!/bin/bash -e

TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source ${TOPDIR}/common.sh

echo "Clear table"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.4.1.11.10 i 6
