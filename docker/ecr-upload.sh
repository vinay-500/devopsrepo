#!/bin/bash

# Download Config file based on the 

#########################
# Check Params

usage()
{
  echo "Usage: $0 [-d DOCKER] [-v VERSION]"
  exit 2
}


set_variable()
{
  local varname=$1
  shift
  if [ -z "${!varname}" ]; then
    eval "$varname=\"$@\""
  else
    echo "Error: $varname already set"
    usage
  fi
}

unset DOCKER VERSION

while getopts ':d:v:' c
do
  case $c in
    d) set_variable DOCKER $OPTARG ;;
    v) set_variable VERSION $OPTARG ;;
    h|?) usage ;; 
  esac
done

echo "Building docker"

[ -z "$DOCKER" ] && echo 'DOCKER is missing ' &&usage
[ -z "$VERSION" ] && echo 'Version is missing ' &&usage

#########################
# Main script starts here

echo "Deploying ${DOCKER}-${VERSION}"

# Get Docker Login
export AWS_ACCESS_KEY_ID="AKIARPO5UOVGNOZMZ7UV"
export AWS_SECRET_ACCESS_KEY="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"
aws_login=$(aws ecr get-login --region="us-east-2" | sed -e "s/-e none//g" | sed 's|https://||')
echo $aws_login
$aws_login

export REPO="101933413708.dkr.ecr.us-east-2.amazonaws.com/cloud"

# Build and push <3
echo docker tag ${DOCKER}:${VERSION} $REPO:${DOCKER}-${VERSION}
docker tag ${DOCKER}:${VERSION} $REPO:${DOCKER}-${VERSION}

echo docker push $REPO:${DOCKER}-${VERSION}
docker push $REPO:${DOCKER}-${VERSION}

echo $REPO:${DOCKER}-${VERSION}
