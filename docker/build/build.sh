#!/bin/bash

# Exit if something breaks
set -e

DIR="/appup-src"

# Check if src folder is mounted - if not..
if [ -d "$DIR" ]
then
    echo "Found. Compiling each in $DIR!"
else
    echo "$DIR directory not found! Are you a developer?"
    exit
fi

mkdir -p /appup_lib/jars/appup_jars /appup_lib/jars/dependencies
 
mvn install -f /appup-src/appup-steps-api-repo
mvn install -f /appup-src/appup-steps-repo
mvn install -f /appup-src/appup-steps-external-repo
mvn install -f /appup-src/appup-core-repo 