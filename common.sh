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

echo_ () { #common format for in-line messages
   echo ""
   echo ">> $* "
   echo ""
}

pause() {
   echo ""
   read -p ">> $* "
   echo ""
}

sleep_ () { # number of seconds to sleep
secs=$1
echo_ Sleep for $1 seconds...
(
trap printout SIGINT
printout () {
 echo "...continuing"
 exit
}
while [ $secs -gt 0 ]; do
   echo -ne "$secs\033[0K\r"
   sleep 1
   : $((secs--))
done
)
}

set_date() { # arg is additional minutes to add to the current time/date
  echo $(date -u +'%Y%m%d%H%M' -d "$1")
  #$(set_date "+1 minute") - time ahead by 1 minute
  #$(set_date "+0 minute") - current time
}

set_new_date() { # arg is additional minutes to add to the current time/date
    local DS_YEAR
    local DS_MON
    local DS_DAY
    local DS_HR
    local DS_MIN
    printf -v DS_YEAR '%04x' `date -u +'%Y'`
    printf -v DS_MON '%02x' `date -u +'%m'`
    printf -v DS_DAY '%02x' `date -u +'%d'`
    printf -v DS_HR '%02x' `date -u +'%H'`
    printf -v DS_MIN '%02x' `date -u +'%M' -d "$1"`
    echo $(echo $DS_YEAR$DS_MON$DS_DAY$DS_HR$DS_MIN)
  #$(set_date "+1 minute") - time ahead by 1 minute
  #$(set_date "+0 minute") - current time
}
