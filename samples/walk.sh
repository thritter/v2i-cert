#!/bin/bash -e

#set -x
TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source ${TOPDIR}/common.sh

echo "Walk tree"
snmpwalk ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}
