#!/bin/bash

if [ "${TOPDIR}" = "" ]; then
  echo "Need TOPDIR defined"
  exit 1
fi

ARGS=(`cat ${TOPDIR}/sut.txt`)

export SUT_IP="${ARGS[0]}"
export SUT_ADDR="udp:${ARGS[0]}:161"
export SUT_NETIF=${ARGS[4]}
export RW_AUTH_ARGS="-t 2 -v 3 -l authPriv -a SHA -A ${ARGS[2]} -x AES -X ${ARGS[3]} -u ${ARGS[1]}  -mRSU-MIB"
export RW_AUTH_ARGS_WRONG_CRED="-t 2 -v 3 -l authPriv -a SHA -A 'invalidPassword' -x AES -X ${ARGS[3]} -u ${ARGS[1]}"

export RSU_MIB="iso.0.15628.4.1"
export MGMT_MIB_2="iso.3.6.1.2.1"

export IFM_PORT=1516

get_ipv6_from_netif_colon() { # arg is netif
  ip addr show dev $1 | sed -e's/^.*inet6 \([^ ]*\)\/.*$/\1/;t;d'
}

get_ipv6_from_netif_hex() { # arg is netif
  cat /proc/net/if_inet6 | grep $1 | cut -f1 -d' '
}

pause() {
   read -p "$*"
}