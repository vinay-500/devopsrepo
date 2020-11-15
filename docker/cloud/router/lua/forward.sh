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

check_dns()
{
    # Check in DNS, return the target available
    DNS=$CLOUD_ID-$APP_ID.appup.ch
    result=$(dig @8.8.8.8 +short -t srv $DNS.|grep 10|cut -d " " -f 3,4)

    # If result is there
    if [ ! -z "$result" ]; then
        stringarray=($result)
        port=${stringarray[0]}
        ip=${stringarray[1]}
        ip=${ip%?}
        printf $ip:$port
        exit 0
    fi
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

check_dns

# If not there
# Call agent 
agent=$(dig @8.8.8.8 +short -t A agents.appup.ch | head -n 1)
if [ -z "$agent" ]; then
    echo "::ERROR:: Error: Agent not available in DNS"
    exit 2
fi


# Sleep till DNS is available
curl -s "http://$agent/appup?cloudid=${CLOUD_ID}&appid=$APP_ID&command=start"  > /dev/null
sleep 5

check_dns
sleep 5
check_dns
sleep 5
check_dns
sleep 5
check_dns
# Hit start