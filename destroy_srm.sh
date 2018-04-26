#!/bin/bash -e

#set -x
source common.sh

echo "Destroy entry (set row status to erase)"
snmpset ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}.4.1.11.0 i 6
