#!/bin/bash -e

#set -x
TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source ${TOPDIR}/common.sh

echo_ "snmpget ${RW_AUTH_ARGS} ${SUT_IP} SNMP-FRAMEWORK-MIB::snmpEngineID.0"

snmpget ${RW_AUTH_ARGS} ${SUT_IP} SNMP-FRAMEWORK-MIB::snmpEngineID.0

