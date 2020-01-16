#!/bin/bash -x

# -e  Exit immediately if a command exits with a non-zero status.
set -e

sudo yum remove java-1.5-* -y

sudo yum install java-1.6.0-openjdk.x86_64 -y

echo export JAVA_HOME=/usr/lib/jvm/java-1.6.0-openjdk-1.6.0.0.x86_64/jre >> ~/.bashrc
echo export PATH=$PATH:$JAVA_HOME/bin >> ~/.bashrc
echo export CLASSPATH=.:$JAVA_HOME/jre/lib:$JAVA_HOME/lib:$JAVA_HOME/lib/tools. >> ~/.bashrc

source ~/.bashrc

echo $JAVA_HOME
echo $PATH
echo $CLASSPATH

java -version
