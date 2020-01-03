#!/bin/bash -x

# -e  Exit immediately if a command exits with a non-zero status.
set -e

export RDECK_BASE=~/rundeck;
sudo mkdir -p $RDECK_BASE

wget https://dl.bintray.com/rundeck/rundeck-maven/rundeck-3.2.0-20191218.war -P /tmp
sudo mv /tmp/rundeck-3.2.0-20191218.war $RDECK_BASE

cd $RDECK_BASE
sudo chown root:root rundeck-3.2.0-20191218.war
ls -la

java -Xmx1g -jar rundeck-3.2.0-20191218.war
PATH=$PATH:$RDECK_BASE/tools/bin
MANPATH=$MANPATH:$RDECK_BASE/docs/man