#!/bin/bash

sudo yum update
sudo yum install -y docker jq nc
sudo service docker start
sudo yum install -y java-1.8.0-openjdk

#wget http://mirrors.estointernet.in/apache//jmeter/binaries/apache-jmeter-5.2.1.tgz
#tar xvf apache*