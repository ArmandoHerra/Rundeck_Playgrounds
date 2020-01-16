#!/bin/bash -x

# -e  Exit immediately if a command exits with a non-zero status.
set -e

> instance.txt

./ami.sh
cd ./terraform
terraform fmt
terraform validate
terraform apply -auto-approve
terraform output Rundeckv1_IP

preinstance_id=$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=Rundeck Playground v1.4.4,Name=instance-state-name, Values=running" \
	--query "Reservations[*].Instances[*].{ID:InstanceId}" \
	--region us-east-1 \
	| grep "i-[a0-z9]*" \
	| cut -d "\"" -f 4)

echo $preinstance_id > instance.txt
instance_id=$(awk '{ print $2 }' instance.txt)
sleep 45

aws ssm send-command \
    --instance-ids $instance_id \
    --document-name "AWS-RunShellScript" \
    --parameters commands=["cd /home/centos/rundeck/ && java -jar rundeck-launcher-1.4.4.jar &"] \
    --comment "Initiate Rundeck" \
    --region us-east-1 \
    --debug

rm instance.txt -f
