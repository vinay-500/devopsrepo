#!/bin/bash

# Get Docker Login
export AWS_ACCESS_KEY_ID="AKIASC3EDSPOBI3KKMF2"
export AWS_SECRET_ACCESS_KEY="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"
aws_login=$(aws ecr get-login --region="us-east-1" | sed -e "s/-e none//g" | sed 's|https://||')
echo $aws_login
sudo $aws_login

sudo service docker start
sudo docker pull 143554483164.dkr.ecr.us-east-1.amazonaws.com/appup:appup-server-0.2
sudo docker tag 143554483164.dkr.ecr.us-east-1.amazonaws.com/appup:appup-server-0.2 appup-server:latest

# Copy 
id=$(sudo docker create appup-server:latest)
sudo docker cp $id:/appup_lib /appup_lib