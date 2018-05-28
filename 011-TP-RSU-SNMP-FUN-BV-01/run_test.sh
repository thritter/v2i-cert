#!/bin/bash -e

# Verify that the roadside unit shall forward WSMP messages received on any DSRC
# interface, containing a specified PSID, to a specified network host, as configured in
# SNMPv3 MIB OID 1.0.15628.4.1.7.

echo "Execute TP-RSU-SNMP-FUN-BV-01"

#set -x
TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source ${TOPDIR}/common.sh

OWN_IP=$(get_ipv6_from_netif_hex ${SUT_NETIF})
OWN_PORT=2099

#DATE_START=$(date -u +'%Y%m%d%H%M' -d "+1 minute")
#DATE_END=$(date -u +'%Y%m%d%H%M' -d "+3 minute")
DATE_START=$(set_date "+1 minute") 
DATE_END=$(set_date "+3 minute")

echo "Install forward PSID=32 to ${OWN_IP} from ${DATE_START} to ${DATE_END}"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.7.1.11.1 i 4
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
  ${RSU_MIB}.7.1.2.1 x 20 \
  ${RSU_MIB}.7.1.3.1 x ${OWN_IP} \
  ${RSU_MIB}.7.1.4.1 i ${OWN_PORT} \
  ${RSU_MIB}.7.1.5.1 i 2 \
  ${RSU_MIB}.7.1.6.1 i -100 \
  ${RSU_MIB}.7.1.7.1 i 1 \
  ${RSU_MIB}.7.1.8.1 x ${DATE_START} \
  ${RSU_MIB}.7.1.9.1 x ${DATE_END}
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.7.1.10.1 i 1

echo "Start WSM transmission now"
set +e
sudo nc -6 -kluv -p ${OWN_PORT}
set -e

pause "Hit Enter to clear table"

echo "Clear table"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.7.1.11.1 i 6

echo "TP-RSU-SNMP-FUN-BV-01 succeeded"
