#!/bin/bash -e

# Each DSRC radio in the roadside unit SHALL be configurable to send messages either
# on Channel 178 during the Control Channel (CCH) interval or on any of the 10 MHz or
# 20 MHz channels with no time interval restrictions.

function tune_channels() {
    echo "Tune channels 178 Alt, $1 Alt"

    snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
        ${RSU_MIB}.12.1.6.0 i 6

    snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
        ${RSU_MIB}.12.1.3.0 i 1 \
        ${RSU_MIB}.12.1.4.0 i 178 \
        ${RSU_MIB}.12.1.5.0 i $1 \
        ${RSU_MIB}.12.1.6.0 i 4
}

function set_srm_channel() {
    echo "Set channel $1 on WSM2"

    snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
        ${RSU_MIB}.4.1.5.1 i $1
}

# ---------------------------------------------------------------

echo "Execute 062-TP-RSU-1609-4-TXT-BV-01"

TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source ${TOPDIR}/common.sh

# set -x

DATE_START=$(date -u +'%Y%m%d%H%M' -d "+1 min")
DATE_END=$(date -u +'%Y%m%d%H%M' -d "+8 min")
CHANNELS=(172 174 176 180 182 184)

snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
    ${RSU_MIB}.12.1.6.0 i 4

echo "Install WSM1 SRM PSID 8002 from ${DATE_START} till ${DATE_END} / disabled"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
    ${RSU_MIB}.4.1.2.0 x 8002 \
    ${RSU_MIB}.4.1.3.0 i 1 \
    ${RSU_MIB}.4.1.4.0 i 0 \
    ${RSU_MIB}.4.1.5.0 i 178 \
    ${RSU_MIB}.4.1.6.0 i 100 \
    ${RSU_MIB}.4.1.7.0 x "${DATE_START}" \
    ${RSU_MIB}.4.1.8.0 x "${DATE_END}" \
    ${RSU_MIB}.4.1.9.0 x 00125408010209c8c3bb265d9cf5e1d282b4ca70583260c1901f4808a4c305d8ea279d4e0450020800000400000200800100400580408000004000002008001004000801012c0304000002000001004000802000401010 \
    ${RSU_MIB}.4.1.10.0 i 1 \
    ${RSU_MIB}.4.1.11.0 i 4

echo "Install WSM2 SRM PSID 8003 from ${DATE_START} till ${DATE_END} / disabled"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
    ${RSU_MIB}.4.1.2.1 x 8003 \
    ${RSU_MIB}.4.1.3.1 i 2 \
    ${RSU_MIB}.4.1.4.1 i 0 \
    ${RSU_MIB}.4.1.6.1 i 100 \
    ${RSU_MIB}.4.1.7.1 x "${DATE_START}" \
    ${RSU_MIB}.4.1.8.1 x "${DATE_END}" \
    ${RSU_MIB}.4.1.9.1 x 00125408010209c8c3bb265d9cf5e1d282b4ca70583260c1901f4808a4c305d8ea279d4e0450020800000400000200800100400580408000004000002008001004000801012c0304000002000001004000802000401010 \
    ${RSU_MIB}.4.1.10.1 i 1 \
    ${RSU_MIB}.4.1.11.1 i 4

# ---------------------------------------------------------------

echo "Waiting 1min"
sleep 60

for i in "${CHANNELS[@]}"
do
    tune_channels $i
    set_srm_channel $i

    echo "Check WMS1 and WSM2 transmission (Start +0min, Stop +1min)"
    sleep 60
done

echo "Clear SNMP table"
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.4.1.11.0 i 6
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.4.1.11.1 i 6
snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} ${RSU_MIB}.12.1.6.0 i 6

echo "Done 062-TP-RSU-1609-4-TXT-BV-01"
