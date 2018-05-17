#!/bin/bash -e

# Verify that the RSU changes message transmit parameters when the RSU Store &
# Repeat Message (SRM) proxy configuration is altered

echo "Execute 052-TP-RSU-MSG-BV-02"

TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source ${TOPDIR}/common.sh

# set -x

DATE_START1=$(date -u +'%Y%m%d%H%M' -d "+0 min")
DATE_START2=$(date -u +'%Y%m%d%H%M' -d "+1 min")

DATE_END1=$(date -u +'%Y%m%d%H%M' -d "+4 min")
DATE_END2=$(date -u +'%Y%m%d%H%M' -d "+5 min")

echo "Install SRM from ${DATE_START1} till ${DATE_END1} / disabled"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
    ${RSU_MIB}.4.1.2.0 x 8002 \
    ${RSU_MIB}.4.1.3.0 i 1 \
    ${RSU_MIB}.4.1.4.0 i 0 \
    ${RSU_MIB}.4.1.5.0 i 172 \
    ${RSU_MIB}.4.1.6.0 i 1000 \
    ${RSU_MIB}.4.1.7.0 x "${DATE_START1}" \
    ${RSU_MIB}.4.1.8.0 x "${DATE_END1}" \
    ${RSU_MIB}.4.1.9.0 x 00125408010209c8c3bb265d9cf5e1d282b4ca70583260c1901f4808a4c305d8ea279d4e0450020800000400000200800100400580408000004000002008001004000801012c0304000002000001004000802000401010 \
    ${RSU_MIB}.4.1.10.0 i 1 \
    ${RSU_MIB}.4.1.11.0 i 4

echo "Check MAP transmission (Start +0min, Stop +4min)"
sleep 60

echo "Change SRM from ${DATE_START2} till ${DATE_END2} / disabled"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
    ${RSU_MIB}.4.1.2.0 x 8003 \
    ${RSU_MIB}.4.1.4.0 i 1 \
    ${RSU_MIB}.4.1.5.0 i 178 \
    ${RSU_MIB}.4.1.7.0 x "${DATE_START2}" \
    ${RSU_MIB}.4.1.8.0 x "${DATE_END2}"

echo "Check MAP transmission (Start +1min, Stop +4min)"
sleep 60

echo "Clear table"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.4.1.11.0 i 6


echo "Done 052-TP-RSU-MSG-BV-02"