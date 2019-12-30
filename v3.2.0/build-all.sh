#!/bin/bash -x

# -e  Exit immediately if a command exits with a non-zero status.
set -e

./ami.sh
cd ./terraform
terraform fmt
terraform validate
terraform apply -auto-approve
terraform output RunDeckv3_IP