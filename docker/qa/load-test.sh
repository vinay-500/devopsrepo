#!/bin/bash


unset IO WORKER_THREADS TEST_CONCURRENT  TEST_LOOP TEST_RAMPUP

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

while getopts ':i:w:c:l:r:t:' c
do
  case $c in
    i) set_variable IO $OPTARG ;;
    w) set_variable WORKER_THREADS $OPTARG ;;
    c) set_variable TEST_CONCURRENT $OPTARG ;;
    l) set_variable TEST_LOOP $OPTARG ;;
    r) set_variable TEST_RAMPUP $OPTARG ;;
    t) set_variable TEST_LIMIT $OPTARG ;;
  esac
done

# echo "Load Testing"

[ -z "$IO" ] && echo 'IO is missing ' &&usage
[ -z "$WORKER_THREADS" ] && echo 'Worker Threads is missing ' &&usage
[ -z "$TEST_CONCURRENT" ] && echo 'Concurrency is missing ' &&usage
[ -z "$TEST_LOOP" ] && echo 'Loop is missing ' &&usage
[ -z "$TEST_RAMPUP" ] && echo 'Rampup is missing ' &&usage
[ -z "$TEST_LIMIT" ] && echo 'Limit is missing ' &&usage


[ -z "$APPUP_JAR" ] && echo 'Appup Jar is not set ' &&usage
[ -z "$JMETER" ] && echo 'JMeter is not set ' &&usage

#########################
# Main script starts here

cat config-meta.json | jq ".server.IO_THREADS = ${IO}" | jq ".server.WORKER_THREADS = ${WORKER_THREADS}" > config.json
echo "Testing server with io:${IO}  worker:${WORKER_THREADS} concurrent:${TEST_CONCURRENT} ramp:$TEST_RAMPUP loop:$TEST_LOOP limit:$TEST_LIMIT"
#sudo java  -Dlog4j.configurationFile=log4j1.xml -cp "$APPUP_JAR/appup_jars/appup-core.jar:$APPUP_JAR/appup_jars/*:$APPUP_JAR/dependencies/*" com.appup.platform.AppletApplication config.json dev > /dev/null 2>&1 &
sudo java  -Dlog4j.configurationFile=log4j1.xml -cp "/appup_lib/jars/appup-core.jar:/appup_lib/jars/appup_jars/*:/appup_lib/jars/dependencies/*" com.appup.platform.AppletApplication config.json dev

PID=$!
# echo "Server started with $PID" 

# Wait till server is accepting connections
while ! echo exit | nc localhost 8080; do sleep 2; done

#echo "Server ready"
sleep 2;

# Run JMeter
#echo "Testing with ${TEST_CONCURRENT} $TEST_RAMPUP $TEST_LOOP"
$JMETER -Jthreads=${TEST_CONCURRENT} -Jrampup=$TEST_RAMPUP -Jloop=$TEST_LOOP -Jlimit=$TEST_LIMIT -n -t Pushly_postman.postman_collection.jmx > dump

# Get Summary only 
cat dump | grep 'summary ='
echo " " 

# Kill Server
sudo kill $PID