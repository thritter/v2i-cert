#!/bin/bash -e

# Verify that the RSU changes message transmit parameters when the RSU Store &
# Repeat Message (SRM) proxy configuration is altered



TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source ${TOPDIR}/common.sh
echo_ "Execute 052-TP-RSU-MSG-BV-02"
# set -x

DATE_START1=$(set_date "+0 min")
DATE_START2=$(set_date "+1 min")

DATE_END1=$(set_date "+4 min")
DATE_END2=$(set_date "+5 min")

echo_ "Install SRM from ${DATE_START1} till ${DATE_END1} / disabled"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
    ${RSU_MIB}.4.1.2.20 x 8002 \
    ${RSU_MIB}.4.1.3.20 i 31 \
    ${RSU_MIB}.4.1.4.20 i 0 \
    ${RSU_MIB}.4.1.5.20 i 172 \
    ${RSU_MIB}.4.1.6.20 i 1000 \
    ${RSU_MIB}.4.1.7.20 x "${DATE_START1}" \
    ${RSU_MIB}.4.1.8.20 x "${DATE_END1}" \
    ${RSU_MIB}.4.1.9.20 x 00125408010209c8c3bb265d9cf5e1d282b4ca70583260c1901f4808a4c305d8ea279d4e0450020800000400000200800100400580408000004000002008001004000801012c0304000002000001004000802000401010 \
    ${RSU_MIB}.4.1.10.20 i 1 \
    ${RSU_MIB}.4.1.11.20 i 4

echo_ "Check MAP transmission (Start +0min, Stop +4min)"
sleep_ 60

echo_ "Change SRM from ${DATE_START2} till ${DATE_END2} / disabled"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
    ${RSU_MIB}.4.1.2.20 x 8003 \
    ${RSU_MIB}.4.1.4.20 i 1 \
    ${RSU_MIB}.4.1.5.20 i 178 \
    ${RSU_MIB}.4.1.7.20 x "${DATE_START2}" \
    ${RSU_MIB}.4.1.8.20 x "${DATE_END2}"

echo_ "Check MAP transmission (Start +1min, Stop +4min)"
sleep_ 60

echo_ "Clear table"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.4.1.11.20 i 6


echo_ "Done 052-TP-RSU-MSG-BV-02"