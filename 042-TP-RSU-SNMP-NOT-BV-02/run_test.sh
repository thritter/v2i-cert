#!/bin/bash -e

# Verify that multiple users can access RSU with different valid SNMPv3 authentication credentials
# Verify that RSU sends a notification if a configurable number of consecutive
# authentication attempts have failed.

# auth failed threshold doesn't have any OID defined, so changing the threshold has to be done manually via WebUI or Xfer

TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source ${TOPDIR}/common.sh

# set -x

echo_ "Execute TP-RSU-SNMP-NOT-BV-02"

echo_ "Sending snmpwalk with correct credentials"

snmpwalk ${RW_AUTH_ARGS} ${SUT_ADDR} \
  ${RSU_MIB}
  
echo_ "Sending multiple snmpwalk calls with incorrect credentials"

set +e
snmpwalk ${RW_AUTH_ARGS_WRONG_CRED} ${SUT_ADDR} \
  ${RSU_MIB}
  
snmpwalk ${RW_AUTH_ARGS_WRONG_CRED} ${SUT_ADDR} \
  ${RSU_MIB}
set -e
  
echo_ "Check that SUT sends trap with auth error (containing string 'SNMP Authentication failed')"
sleep 30

echo_ "Done TP-RSU-SNMP-NOT-BV-02"
