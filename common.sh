#!/bin/bash

if [ "${TOPDIR}" = "" ]; then
  echo "Need TOPDIR defined"
  exit 1
fi

ARGS=(`cat ${TOPDIR}/sut.txt`)

export SUT_IP="udp:${ARGS[0]}:10161"
export RSU_MIB="iso.0.15628.4.1"
export RW_AUTH_ARGS="-t 2 -v 3 -l authPriv -a SHA -A ${ARGS[2]} -x AES -X ${ARGS[3]} -u ${ARGS[1]}"
