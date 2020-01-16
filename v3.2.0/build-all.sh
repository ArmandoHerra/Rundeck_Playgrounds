#!/bin/bash -x

# -e  Exit immediately if a command exits with a non-zero status.
set -e

keypair_exists=$(aws ec2 describe-key-pairs \
    | grep "Rundeck-Playgrounds" \
    | cut -d "\"" -f 4)

if [[ $keypair_exists == "Rundeck-Playgrounds" ]]; then
    echo "Keypair found, continuing..."
else
    echo -e "No Keypair Found, generating one..."
    aws ec2 create-key-pair --key-name Rundeck-Playgrounds --query 'KeyMaterial' --output text > ~/.ssh/Rundeck-Playgrounds.pem
fi

./ami.sh
cd ./terraform
terraform init
terraform fmt
terraform validate
terraform apply -auto-approve
terraform output Rundeckv3_IP