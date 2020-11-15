#!/bin/bash

usage()
{
  echo "::ERROR:: Usage: $0 [ -c CLOUD_ID] [-a APP_ID]"
  exit 2
}


set_variable()
{
  local varname=$1
  shift
  if [ -z "${!varname}" ]; then
    eval "$varname=\"$@\""
  else
    echo "::ERROR:: Error: $varname already set"
    usage
  fi
}

EPHEMERAL_PORT() {
    LOW_BOUND=49152
    RANGE=16384
    while true; do
        CANDIDATE=$[$LOW_BOUND + ($RANDOM % $RANGE)]
        (echo "" >/dev/tcp/127.0.0.1/${CANDIDATE}) >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo $CANDIDATE
            break
        fi
    done
}

unset CLOUD_ID APP_ID

while getopts ':c:a:' c
do
  case $c in
    c) set_variable CLOUD_ID $OPTARG ;;
    a) set_variable APP_ID $OPTARG ;;
    h|?) usage ;; 
  esac
done

[ -z "$CLOUD_ID" ] && echo '::ERROR:: CLOUD_ID is missing ' &&usage
[ -z "$APP_ID" ] && echo '::ERROR:: APP_ID is missing ' &&usage


# Stop Docker
Docker_Name=$CLOUD_ID-$APP_ID
sudo docker logs $Docker_Name --tail 100