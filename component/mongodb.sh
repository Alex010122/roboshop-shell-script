#!/bin/bash
USER_ID=$(id -u)
 if [ $USER_ID -ne 0 ]; then
    echo You are non root user
    echo you can run this script as root user or with sudo
    exit 1
 fi
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo

yum install -y mongodb-org
systemctl enable mongod
systemctl start mongod

sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf

#1. Update Listen IP address from 127.0.0.1 to 0.0.0.0 in config file
#Config file: `/etc/mongod.conf`
#then restart the service


systemctl restart mongod
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"
cd /tmp
unzip -o mongodb.zip
cd mongodb-main
mongo < catalogue.js
mongo < users.js
##Every Database needs the schema to be loaded for the application to work.
