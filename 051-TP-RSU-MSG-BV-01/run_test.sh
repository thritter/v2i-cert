#!/bin/bash -e

# Verify that the RSU transmits MAP messages (i.e. MessageFrame containing
# MSG_MapData per [11]) according to the specified Time instructions



TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source ${TOPDIR}/common.sh
echo_ "Execute TP-RSU-SNMP-NOT-BV-03"
# set -x

#snmpwalk ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.4
DATE_START=$(date -u +'%Y%m%d%H%M' -d "+1 min")
DATE_END=$(date -u +'%Y%m%d%H%M' -d "+2 min")

echo_ "Install SRM from ${DATE_START} till ${DATE_END} / disabled"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
  ${RSU_MIB}.4.1.10.10 i 0 \
  ${RSU_MIB}.4.1.11.10 i 4

snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
  ${RSU_MIB}.4.1.2.10 x 8002 \
  ${RSU_MIB}.4.1.3.10 i 18 \
  ${RSU_MIB}.4.1.4.10 i 1 \
  ${RSU_MIB}.4.1.5.10 i 172 \
  ${RSU_MIB}.4.1.6.10 i 1000 \
  ${RSU_MIB}.4.1.9.10 x 00125408010209c8c3bb265d9cf5e1d282b4ca70583260c1901f4808a4c305d8ea279d4e0450020800000400000200800100400580408000004000002008001004000801012c0304000002000001004000802000401010 \

snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
  ${RSU_MIB}.4.1.7.10 x "${DATE_START}" \
  ${RSU_MIB}.4.1.8.10 x "${DATE_END}" \
  ${RSU_MIB}.4.1.10.10 i 1

echo_ "Check MAP transmission (Start +1min, Stop +2min)"
snmpwalk ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.4
sleep_ 180

echo_ "Clear table"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.4.1.11.10 i 6

echo_ "Done TP-RSU-MSG-BV-01"
