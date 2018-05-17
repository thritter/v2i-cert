#!/bin/bash -e

# Verify that RSU sends a notification if a time source input has been lost for a
# configurable period or has failed after a configurable number of query attempts (note:
# the time source itself shall also be indicated) (OID 1.0.15628.4.1.100.0.7)

echo "Execute TP-RSU-SNMP-NOT-BV-03"

TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source ${TOPDIR}/common.sh

# set -x


echo "Verify that rsuGpsStatus show 4 or more satellites"

snmpget ${RW_AUTH_ARGS} ${SUT_ADDR} \
  ${RSU_MIB}.3
  
echo "Changing notification threshold limit for rsuTimeSourceLostMsg to 10s"

snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
  ${RSU_MIB}.100.1.7 i 10

echo "Remove GPS antenna"
sleep 60

echo "Verify that rsuGpsStatus show 0 satellites"
snmpget ${RW_AUTH_ARGS} ${SUT_ADDR} \
  ${RSU_MIB}.3
  
echo "Check that SUT sent trap with time source lost msg"
sleep 60

echo "Done TP-RSU-SNMP-NOT-BV-03"
