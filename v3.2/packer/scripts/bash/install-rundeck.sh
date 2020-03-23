#!/bin/bash -x

# -e  Exit immediately if a command exits with a non-zero status.
set -e

sudo rpm -Uvh http://repo.rundeck.org/latest.rpm
sudo yum install rundeck -y