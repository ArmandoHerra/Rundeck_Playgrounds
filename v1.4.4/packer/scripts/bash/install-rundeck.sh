#!/bin/bash -x

# -e  Exit immediately if a command exits with a non-zero status.
set -e

# sudo yum install rpmrebuild -y

wget https://download.rundeck.org/jar/rundeck-launcher-1.4.4.jar

echo export RDECK_BASE=~/rundeck >> ~/.bashrc
echo export PATH=$PATH:$RDECK_BASE/tools/bin >> ~/.bashrc
echo export MANPATH=$MANPATH:$RDECK_BASE/docs/man >> ~/.bashrc
source ~/.bashrc

mkdir -p $RDECK_BASE

cp rundeck-launcher-1.4.4.jar $RDECK_BASE

# cd $RDECK_BASE && java -jar rundeck-launcher-1.4.4.jar &