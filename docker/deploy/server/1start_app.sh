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


if [[ -z "${JMX_PORT}" ]]; then
    echo "Port IS NOT PROVIDED - using default - 80"
    JMX_PORT=9091
fi

# SRVC_NAME

# Download config.json
export AWS_ACCESS_KEY_ID=AKIA5QMVMZUCA3GXN5HI
export AWS_SECRET_ACCESS_KEY=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
aws s3 cp s3://appup-config/${CLOUD_ID}/${SVC_NAME}/config.json .

echo "Changing port "
jq '.server.port="'${PORT}'"' config.json >> config2.json
rm config.json

echo downloading the jar 
aws s3 cp s3://appup-bucket/${CLOUD_ID}/${SVC_NAME}/appup_lib/jars/user_jars/java-compile-1.0.jar  /appup_lib/jars/user_jars/java-compile-1.0.jar

export ENV=prod
#cat config2.json
#java -Dlog4j.configurationFile=/server/log4j.xml -cp "/appup_lib/jars/appup-core.jar:/appup_lib/jars/appup_jars/*:/appup_lib/jars/dependencies/*" com.appup.platform.AppletApplication config2.json  -Dcom.sun.management.jmxremote.rmi.port=9090  -Dcom.sun.management.jmxremote=true  -Dcom.sun.management.jmxremote.authenticate=false  -Dcom.sun.management.jmxremote.ssl=false  -Dcom.sun.management.jmxremote.port=9090  -Djava.rmi.server.hostname=172.17.0.2 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.local.only=false

#java -Dlog4j.configurationFile=/server/log4j2.xml -cp "/appup_lib/jars/appup-core.jar:/appup_lib/jars/appup_jars/*:/appup_lib/jars/dependencies/*" com.appup.platform.AppletApplication config2.json -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9090 -Dcom.sun.management.jmxremote.rmi.port=9090 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.local.only=false -Djava.rmi.server.hostname=0.0.0.0   -Dcom.sun.management.jmxremote.host=0.0.0.0
#
java -Dlog4j.configurationFile=/server/log4j2.xml -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.port=9091 -Dcom.sun.management.jmxremote.rmi.port=9091 -Dcom.sun.management.jmxremote.host=0.0.0.0 -Djava.rmi.server.hostname=0.0.0.0  -cp "/appup_lib/jars/appup-core.jar:/appup_lib/jars/appup_jars/*:/appup_lib/jars/dependencies/*" com.appup.platform.AppletApplication config2.json
