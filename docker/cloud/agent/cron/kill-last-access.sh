#!/bin/bash

# Get all dockers running
dockers='docker container ls --format "{{.Names}}"'

# Get all routers for appup.ch
routers='dig +short -t A routers.appup.ch'

# For each docker - see if there is a DNS, otherwise kill it - can be zombies
while read -r docker
do
    echo "Checking $docker"

        # Each router
        last_access=0
        while read -r router
        do
            time=$(curl -s "http://$router/_appup_logs?cloudid=${CLOUD_ID}&appid=$APP_ID&command=access")
            [ ! -z time ] && [ $last_access -gt $time ] && last_access=$time
            echo "Last log for $docker: $last_access"
        done < <($routers)
done < <($dockers)