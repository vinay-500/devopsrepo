#!/bin/bash

sudo yum update
sudo yum-config-manager --add-repo https://openresty.org/package/amazon/openresty.repo
sudo yum install -y openresty python3-pip docker jq
sudo pip3 install awscli --upgrade

# Get Docker Login
export AWS_ACCESS_KEY_ID="AKIASC3EDSPOBI3KKMF2"
export AWS_SECRET_ACCESS_KEY="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"
aws_login=$(aws ecr get-login --region="us-east-1" | sed -e "s/-e none//g" | sed 's|https://||')
echo $aws_login
sudo $aws_login

sudo service docker start
sudo docker pull 143554483164.dkr.ecr.us-east-1.amazonaws.com/appup:appup-server-0.2
sudo docker tag 143554483164.dkr.ecr.us-east-1.amazonaws.com/appup:appup-server-0.2 appup-server:latest

# Install file which is ready
sudo echo 'test' > /done.text