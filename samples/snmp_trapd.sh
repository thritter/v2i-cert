#!/bin/bash -e
# http://net-snmp.sourceforge.net/docs/man/snmptrapd.html
#set -x
TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source ${TOPDIR}/common.sh

#echo_ "Configuring notification port"
OWN_IP=$(get_ipv6_from_netif_hex ${SUT_NETIF})
OWN_PORT=162

echo_ "Sending notifications to $OWN_IP $OWN_PORT"

snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
  ${RSU_MIB}.18.2.0 x ${OWN_IP} \
  ${RSU_MIB}.18.3.0 i ${OWN_PORT}

#snmpwalk ${RW_AUTH_ARGS} ${SUT_IP} ${RSU_MIB}.18
  
echo_ "Starting snmptrapd"
snmptrapd -n -t -f -Lo udp6:[::]:162 -c ./snmptrapd.conf -F "%02.2h:%02.2j:%02.2k TRAP%w.%q (%W) from %A\n"
# -t Do not log traps to syslog. 
# -f Do not fork() from the calling shell.
# -n Do not attempt to translate source addresses of incoming packets into hostnames.
# -Lo log to output
# -c config file
