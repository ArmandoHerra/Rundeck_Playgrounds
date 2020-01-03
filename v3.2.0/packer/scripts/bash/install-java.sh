#!/bin/bash -x

# -e  Exit immediately if a command exits with a non-zero status.
set -e

sudo yum install java-1.8.0-openjdk-devel -y
sudo yum install java-1.8.0-openjdk -y
sudo yum install java-1.8.0 -y

echo '1' | sudo update-alternatives --config java

echo export JAVA_HOME=$(dirname $(dirname $(readlink $(readlink $(which javac))))) >> ~/.bashrc
echo export PATH=$PATH:$JAVA_HOME/bin >> ~/.bashrc
echo export CLASSPATH=.:$JAVA_HOME/jre/lib:$JAVA_HOME/lib:$JAVA_HOME/lib/tools. >> ~/.bashrc

sudo cat ~/.bashrc
source ~/.bashrc

echo $JAVA_HOME
echo $PATH
echo $CLASSPATH