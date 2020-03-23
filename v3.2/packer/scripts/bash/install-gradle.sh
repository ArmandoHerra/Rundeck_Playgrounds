#!/bin/bash -x

# -e  Exit immediately if a command exits with a non-zero status.
set -e

wget https://services.gradle.org/distributions/gradle-4.7-bin.zip -P /tmp
sudo unzip -d /opt/gradle /tmp/gradle-4.7-bin.zip
sudo ls -la /opt/gradle/gradle-4.7

export PATH=$PATH:/opt/gradle/gradle-4.7/bin

gradle -v