#!/bin/bash -e

#set -x
TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source ${TOPDIR}/common.sh

echo_ "Walk tree"
echo_ "snmpwalk ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}"

snmpwalk ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}

