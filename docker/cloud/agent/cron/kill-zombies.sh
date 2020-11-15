#!/bin/bash

# Get all dockers running
dockers='docker container ls --format "{{.Names}}"'

# For each docker - see if there is a DNS, otherwise kill it - can be zombies
while read -r docker
do
    docker=$(echo $docker | tr -d '"')
    
    # Get DNS - .appup.ch
    DNS=$docker.appup.ch
    echo "Checking $DNS"
    result=$(dig +short $DNS.)
    echo "DNS result: $result"

    # Kill docker if no DNS result -z zombie..
    if [ -z "$result" ]; then
        echo "Killing zombie docker $docker" 
        docker rm -f $docker
        echo 'Killed Docker'
    fi

done < <($dockers)