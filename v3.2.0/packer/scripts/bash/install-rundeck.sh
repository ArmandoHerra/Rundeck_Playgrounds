#!/bin/bash -x

# -e  Exit immediately if a command exits with a non-zero status.
set -e

sudo rpm -Uvh http://repo.rundeck.org/latest.rpm
sudo yum install rundeck -y

sudo service rundeckd start

sudo cat /etc/rundeck/framework.properties
sudo cat /etc/rundeck/rundeck-config.properties

sudo service rundeckd restart

# echo $JAVA_HOME

# export RDECK_BASE=~/rundeck;
# sudo mkdir -p $RDECK_BASE

# wget https://dl.bintray.com/rundeck/rundeck-maven/rundeck-3.2.0-20191218.war -P /tmp
# sudo mv /tmp/rundeck-3.2.0-20191218.war $RDECK_BASE

# cd $RDECK_BASE
# sudo chown root:root rundeck-3.2.0-20191218.war
# ls -la

# server_addr=$(curl -v http://169.254.169.254/latest/meta-data/public-ipv4)

# java -server -Dserver.session.timeout=3600 -Dserver.port=4440 -Dserver.address=$server_addr -jar rundeck-3.2.0-20191218.war

# PATH=$PATH:$RDECK_BASE/tools/bin
# MANPATH=$MANPATH:$RDECK_BASE/docs/man