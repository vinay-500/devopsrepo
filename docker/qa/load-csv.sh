#!/bin/bash


unset CSV 

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

while getopts ':c:' c
do
  case $c in
    c) set_variable CSV $OPTARG ;;
  esac
done

# echo "Load Testing"

[ -z "$CSV" ] && echo 'CSV is missing ' &&usage

#########################
# Main script starts here
touch appup.log
echo "Test start " > appup.log
echo " " > appup.log

while IFS=',' read -r io worker concurrent ramp loop limit
do 
  echo "$io $worker $concurrent $ramp $loop $limit"
  ./load-test.sh -i $io -w $worker -c $concurrent -r $ramp -l $loop -t $limit >> appup.log
done < "$CSV"