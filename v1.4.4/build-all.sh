#!/bin/bash -x

clear

aws ec2 describe-key-pairs > /dev/null 2>&1
if [ $? -eq 0 ]; then
    keypair_exists=$(aws ec2 describe-key-pairs \
        | grep "Rundeck-Playgrounds" \
        | cut -d "\"" -f 4)
    if [[ $keypair_exists == "Rundeck-Playgrounds" ]]; then
        echo "Keypair found, continuing..."
    else
        echo -e "No Keypair Found, generating one..."
        aws ec2 create-key-pair --key-name Rundeck-Playgrounds --query 'KeyMaterial' --output text > ~/.ssh/Rundeck-Playgrounds.pem
    fi
else
    echo "There is a problem with your AWS CLI Keys, please check them before continuing"
    exit 1
fi

./ami.sh
cd ./terraform
terraform init
terraform fmt
terraform validate
terraform apply -auto-approve
terraform output Rundeckv1_IP

instance_id=$(aws ec2 describe-instances \
    --filters "Name=tag-value,Values=Rundeck Playground v1.4.4" "Name=instance-state-name,Values=running" "Name=instance-type,Values=m4.large" "Name=instance-state-code,Values=16" \
	--query "Reservations[*].Instances[*].{ID:InstanceId}" \
	--region us-east-1 \
	| grep "i-[a0-z9]*" \
	| cut -d "\"" -f 4)

sleep 45

aws ssm send-command \
    --instance-ids $instance_id \
    --document-name "AWS-RunShellScript" \
    --parameters commands=["cd /home/centos/rundeck/ && java -jar rundeck-launcher-1.4.4.jar &"] \
    --comment "Initiate Rundeck" \
    --region us-east-1 \
    --debug
