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

IP_ADDRESS=$(ifconfig eth0 | grep "inet " | cut -d 't' -f 2 | cut -d ' ' -f 2)
[ -z "$IP_ADDRESS" ] && echo '::ERROR:: IP is missing ' &&usage

PORT=$(EPHEMERAL_PORT)
echo "Listening on port ${PORT}"
# Start Docker
Docker_Name=$CLOUD_ID-$APP_ID
docker rm -f $Docker_Name; 
docker run -it -d --name=$Docker_Name -e CLOUD_ID=$CLOUD_ID -e SVC_NAME=$APP_ID -e PORT=${PORT} -p ${PORT}:${PORT} -e APPEND=/$APP_ID appup-server

# AWS Add to Route53
export AWS_ACCESS_KEY_ID=AKIARPO5UOVGGLDGQ3FU
export AWS_SECRET_ACCESS_KEY=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

aws route53 change-resource-record-sets --hosted-zone-id ZNUC5UVXDFSIT  --change-batch '{ "Comment": "Creating a record set from '$CLOUD_ID'", "Changes": [ { "Action": "UPSERT", "ResourceRecordSet": { "Name": "'$CLOUD_ID-$APP_ID.appup.ch'", "Type": "SRV", "TTL": 5, "ResourceRecords": [ { "Value": "1 10 '${PORT}' '${IP_ADDRESS}'" } ] } } ] }'