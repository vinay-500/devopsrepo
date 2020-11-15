#!/bin/bash

# Download Config file based on the 

#########################
# Check Params

usage()
{
  echo "Usage: $0 [ -r REPO ] [ -a ACCESS_KEY] [ -k SECRET_KEY] [-l LIBS] [-s SRC] [-v VERSION]"
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

unset REPO ACCESS_KEY SECRET_KEY LIBS SRC VERSION

while getopts ':r:a:k:l:s:v:' c
do
  case $c in
    r) set_variable REPO $OPTARG ;;
    a) set_variable ACCESS_KEY $OPTARG ;;
    k) set_variable SECRET_KEY $OPTARG ;;
    l) set_variable LIBS $OPTARG ;;
    s) set_variable SRC $OPTARG ;;
    v) set_variable VERSION $OPTARG ;;
    h|?) usage ;; 
  esac
done
echo $LIBS
echo $SRC

echo "Building docker"

[ -z "$LIBS" ] && echo 'Libs is missing ' &&usage
[ -z "$SRC" ] && echo 'SRC is missing ' &&usage
[ -z "$VERSION" ] && echo 'Version is missing ' &&usage

#########################
# Main script starts here

# Docker cannot copy from any folder. So, copy libs and src into temp
cp -R $LIBS server
cp -R $SRC/*.jar server/jars
cd server
docker build -t appup-server:${VERSION} .
echo "Docker built appup-server:${VERSION}"


[ -z "$REPO" ] && echo 'Repo is missing. Not uploading.' && exit 2
[ -z "$ACCESS_KEY" ] && echo 'Access key is missing ' &&usage
[ -z "$SECRET_KEY" ] && echo 'Secret key is missing ' &&usage

echo "Deploying"

# Get Docker Login
export AWS_ACCESS_KEY_ID=$ACCESS_KEY
export AWS_SECRET_ACCESS_KEY=$SECRET_KEY
aws_login=$(aws ecr get-login --region="us-east-1" | sed -e "s/-e none//g" | sed 's|https://||')
echo $aws_login
$aws_login 

# Build and push <3
echo docker tag appup-server:${VERSION} $REPO:appup-server-${VERSION}
docker tag appup-server:${VERSION} $REPO:appup-server-${VERSION}

echo docker push $REPO:appup-server-${VERSION}
#docker push $REPO:appup-server-${VERSION}

# docker tag 3c2fb9cc53db 143554483164.dkr.ecr.us-east-1.amazonaws.com/500apps:nginx-500apps-s3-1.10
# docker push 143554483164.dkr.ecr.us-east-1.amazonaws.com/500apps:nginx-500apps-s3-1.10