#!/bin/bash -e

#set -x
source common.sh

echo "Walk tree"
snmpwalk ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}
