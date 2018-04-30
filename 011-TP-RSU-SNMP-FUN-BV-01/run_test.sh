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

echo "Install forward PSID=32 to ${OWN_IP}"
snmpset ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}.7.1.11.0 i 4
snmpset ${RW_AUTH_ARGS} ${SUT_IP} \
  ${RSU_MIB}.7.1.2.0 x 20 \
  ${RSU_MIB}.7.1.3.0 x ${OWN_IP} \
  ${RSU_MIB}.7.1.4.0 i ${OWN_PORT} \
  ${RSU_MIB}.7.1.5.0 i 2 \
  ${RSU_MIB}.7.1.6.0 i -100  \
  ${RSU_MIB}.7.1.7.0 i  1  \
  ${RSU_MIB}.7.1.8.0 s 201601010000 \
  ${RSU_MIB}.7.1.9.0 s 202612312359
snmpset ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}.7.1.10.0 i 1

echo "Start WSM transmission now"
set +e
sudo nc -6 -kluv -p ${OWN_PORT}
set -e

echo "Clear table"
snmpset ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}.7.1.11.0 i 6

echo "TP-RSU-SNMP-FUN-BV-01 succeeded"
