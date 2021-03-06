#!/bin/bash

# Deploys app.js to a folder
# Usage ./s3-apps-js-deploy.sh -a bugs3 -s app.js

usage()
{
  echo "Usage: $0 [ -a  APP_NAME] [ -s SRC]"
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

unset APP_NAME SRC

while getopts ':r:a:k:l:s:v:' c
do
  case $c in
    a) set_variable APP_NAME $OPTARG ;;
    s) set_variable SRC $OPTARG ;;
    h|?) usage ;; 
  esac
done

[ -z "$APP_NAME" ] && echo 'App name is missing ' &&usage
[ -z "$SRC" ] && echo 'SRC is missing ' &&usage

# Set Creds
export AWS_ACCESS_KEY_ID="AKIASC3EDSPODJJLCAIJ"
export AWS_SECRET_ACCESS_KEY="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"

# Get file extension
basename "$SRC"
filename=${SRC##*/}


# Copy the file to root if index
dest=""
if [[ $filename == index* ]] ; then
  dest=${filename}
else
  dest=${APP_NAME}/${filename}


# Push to s3
  aws s3 cp $SRC s3://500appsapp/frontend/${dest} --acl public-read
  echo https://500appsapp.s3.amazonaws.com/frontend/${dest}
  
  # Invalidate nginx cache
  curl https://${APP_NAME}.500apps.io/${dest} -s -I -H "secret-header:true"
fi