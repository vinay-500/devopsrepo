#!/bin/bash

# Appup server downloads the server file

if [[ -z "${CLOUD_ID}" ]]; then
    echo "Cloud ID IS NOT PROVIDED"
    exit
fi

if [[ -z "${SVC_NAME}" ]]; then
    echo "SVC Name IS NOT PROVIDED"
    exit
fi

if [[ -z "${PORT}" ]]; then
    echo "Port IS NOT PROVIDED - using default - 80"
    PORT=80
fi


# Let's wait for docker stop and if the queue is pending, we will stop
exit_trap()
{
    echo "received SIGTERM, Stopping services..."
    while true: 
    do
        curl localhost:${PORT}/_appup/queue/stop | jq .shutdown | grep -q "true" &&  echo "Shutting down" && exit 0
        sleep 5
    done
    
    # Queues have stopped. We can exit
    exit 0
}
trap exit_trap SIGTERM
# End of SIGTERM

# Download config.json
export AWS_ACCESS_KEY_ID=AKIA5QMVMZUCA3GXN5HI
export AWS_SECRET_ACCESS_KEY=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
aws s3 cp s3://appup-config/${CLOUD_ID}/${SVC_NAME}/config.json .

echo "Changing port "
jq '.server.port="'${PORT}'"' config.json >> config2.json
rm config.json

echo downloading the jar 
#aws s3 cp s3://appup-bucket/${CLOUD_ID}/${SVC_NAME}/appup_lib/jars/user_jars/java-compile-1.0.jar  /appup_lib/jars/user_jars/java-compile-1.0.jar

export ENV=prod

java -Dlog4j.configurationFile=/server/log4j2.xml -Djavax.net.ssl.trustStore=/appup_lib/cassandra_truststore.jks -Djavax.net.ssl.trustStorePassword=123456 -cp "/appup_lib/jars/appup-core.jar:/appup_lib/jars/appup_jars/*:/appup_lib/jars/dependencies/*" com.appup.platform.AppletApplication config2.json






