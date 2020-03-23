#!/bin/bash -x

# -e  Exit immediately if a command exits with a non-zero status.
set -e

wget https://github.com/grails/grails-core/releases/download/v3.3.8/grails-3.3.8.zip -P /tmp
sudo unzip -d /opt/grails /tmp/grails-3.3.8.zip
sudo ls -la /opt/grails/grails-3.3.8

export GRAILS_HOME=/opt/grails/grails-3.3.8
export PATH="$PATH:$GRAILS_HOME/bin"

grails -version