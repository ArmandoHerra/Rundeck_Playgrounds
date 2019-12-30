#!/bin/bash -x

# -e  Exit immediately if a command exits with a non-zero status.
set -e

# Get most recent OS updates and apply them.
sudo yum update -y
sudo yum install epel-release -y

# Install 'curl', 'wget' and 'vim'
sudo yum install curl wget vim -y