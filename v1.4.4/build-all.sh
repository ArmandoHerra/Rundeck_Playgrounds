#!/bin/bash -x

# -e  Exit immediately if a command exits with a non-zero status.
set -e

./ami.sh
cd ./terraform
terraform fmt
terraform validate
terraform apply -auto-approve
terraform output Rundeckv1_IP

instance_id=$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=Rundeck Playground v1.4.4,Name=instance-state-name, Values=running" \
	--query "Reservations[*].Instances[*].{ID:InstanceId}" \
	--region us-east-1 \
	| grep "i-[a0-z9]*" \
	| cut -d "\"" -f 4)

# Set fix on the following CLI command, configure the instance with the appropriate role and permissions to be able to use SSM and Send a remote command.

# Reminder: Install the SSM Agent on the instance first, preferably on the install-base.sh script.

aws ssm send-command \
    --instance-ids "i-0102edf6ab3975c62" \
    --document-name "AWS-RunShellScript" \
    --parameters commands=["echo HelloWorld"] \
    --comment "echo HelloWorld" \
    --region us-east-1 \
    --debug