#!/bin/bash -e

# The roadside unit shall notify a remote host via SNMPv3 if its GPS position deviates
# from the stored reference by more than a configurable radius (OID 1.0.15628.4.1.100.0.11)

echo "Execute TP-RSU-SNMP-POS-BV-01"

TOPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
source ${TOPDIR}/common.sh

# set -x

REF_LAT=100000000
REF_LON=100000000
REF_ELV=0
MAX_DEV=10

echo "Setting initial reference GPS position"

snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
  ${RSU_MIB}.8.6.0 i ${REF_LAT} \
  ${RSU_MIB}.8.7.0 i ${REF_LON} \
  ${RSU_MIB}.8.8.0 i ${REF_ELV} \
  ${RSU_MIB}.8.9.0 i ${MAX_DEV} \

echo "Check that SUT does not generate position deviation notification"
sleep 10

echo "Setting reference latitude to get out of max deviation"

snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
  ${RSU_MIB}.8.6.0 i $((REF_LAT+100))

echo "Check incoming SNMP trap with rsuGpsDeviationMsg"
sleep 10

snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
  ${RSU_MIB}.8.6.0 i ${REF_LAT}
  
echo "Setting reference longitude to get out of max deviation"

snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
  ${RSU_MIB}.8.7.0 i $((REF_LON+100))

echo "Check incoming SNMP trap with rsuGpsDeviationMsg"
sleep 10

snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
  ${RSU_MIB}.8.7.0 i ${REF_LON}
  
    
echo "Setting reference elevation to get out of max deviation"

snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
  ${RSU_MIB}.8.8.0 i $((REF_ELV+100))

echo "Check incoming SNMP trap with rsuGpsDeviationMsg"
sleep 10

snmpset ${RW_AUTH_ARGS} ${SUT_ADDR} \
  ${RSU_MIB}.8.8.0 i ${REF_ELV}


echo "Done TP-RSU-SNMP-POS-BV-01"
