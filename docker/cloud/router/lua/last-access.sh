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

FILE="/usr/local/openresty/nginx/logs/$CLOUD_ID.appup.cloud"
#FILE="test.log"

# Get File
if [ ! -f $FILE ]; then
    echo "::ERROR:: CLOUD_ID has no access logs " 
    exit 2
fi

#echo `grep -m 1 /${APP_ID} $FILE | cut -d '"' -f1 | cut -d "[" -f2 | cut -d "]" -f1`
result=$(grep /${APP_ID} $FILE | tail -1 | cut -d '"' -f1 | cut -d "[" -f2 | cut -d "]" -f1) 
[ -z "$result" ] && echo '::ERROR:: APP_ID is not present in the logs' && exit 2

date2=$(echo $result | sed -e 's,/,-,g' -e 's,:, ,')
#echo $date2

TZ=GMT date +"%s" -d "$date2"