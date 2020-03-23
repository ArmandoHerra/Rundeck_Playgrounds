#!/bin/bash

function clean_ami () {
    clear
    echo -e "~~~~~ Removing previous AMI and related files... ~~~~~\n"
    
    # Remove RUNDECKV1_AMI_ID.log if it exists.
    cat packer/logs/RUNDECKV1_AMI_ID.log > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        previous_RUNDECKV1_AMI=$(cat packer/logs/RUNDECKV1_AMI_ID.log)
        # Deregister EC2 AMI Image
        aws ec2 deregister-image --image-id $previous_RUNDECKV1_AMI --region us-east-1
        rm packer/logs/RUNDECKV1_AMI_ID.log
    else
        echo -e "No File Named RUNDECKV1_AMI_ID.log found, skipping step."
    fi
    
    # Remove the rundeckv1_ami_output.log if it exists.
    cat packer/logs/rundeckv1_ami_output.log > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        rm packer/logs/rundeckv1_ami_output.log
    else
        echo -e "No File Named rundeckv1_ami_output.log found, skipping step.\n"
    fi
    
    > terraform/variables.tf
}

function clean_snapshot () {
    echo -e "~~~~~ Removing previous AMI Snapshot ~~~~~\n"
    
    # Lookup the AMI Snapshot
    SnapshotExists=$(aws ec2 describe-snapshots --filters "Name=tag:Project,Values=Rundeck v1.4.4" --query "Snapshots[*].{ID:SnapshotId}" --region us-east-1)
    if [ "${SnapshotExists[@]}" != "[]" ]; then
        snapID=$(aws ec2 describe-snapshots \
            --filters "Name=tag:Project,Values=Rundeck v1.4.4" \
            --query "Snapshots[*].{ID:SnapshotId}" \
            --region us-east-1 \
            | grep 'snap-[a0-z9]*' \
            | cut -d "\"" -f 4)
        aws ec2 delete-snapshot --snapshot-id $snapID --region us-east-1
    else
        echo -e "No Snapshots found, skipping step.\n"
    fi
}

function build_rundeckv1_ami () {
    echo -e "~~~~~ Validating Rundeckv1 Packer Template ~~~~~ \n"
    rundeckv1_Valid=$(packer validate packer/rundeck-v1.4.4.json)
    
    if [[ $rundeckv1_Valid == "Template validated successfully." ]]; then
        echo -e "Rundeckv1 Template validated successfully"
        echo -e "\nBuilding Rundeckv1 AMI...\n"
        if [ ! -d "packer/logs" ]; then
            mkdir packer/logs
        else
            packer build -color=false packer/rundeck-v1.4.4.json | tee packer/logs/rundeckv1_ami_output.log
            rundeckv1PreExportVar=$(cat packer/logs/rundeckv1_ami_output.log | tail -n 2 \
                | sed '$ d' \
                | sed "s/us-east-1: /variable "\"packer_built_rundeckv1_ami"\" { default = \"/" \
            | sed -e 's/[[:space:]]*$/\"/')
            rundeckv1ExportVar="${rundeckv1PreExportVar} }"
            echo $rundeckv1ExportVar >> terraform/variables.tf
            # Print last two lines of the build logs | Match all cases for 'ami-*' | get the 2md column of the line using a space as delimiter.
            RUNDECKV1_AMI_ID=$(tail -2 packer/logs/rundeckv1_ami_output.log | grep 'ami-[a0-z9]*' | cut -d " " -f 2)
            if [[ $RUNDECKV1_AMI_ID == "" ]]; then
                echo -e "Errors occurred while building the Rundeckv1 Packer Image, please check the logs."
                exit 1
            else
                echo $RUNDECKV1_AMI_ID > packer/logs/RUNDECKV1_AMI_ID.log
                echo
            fi
        fi
    else
        echo -e "Rundeckv1 Packer Template is not valid!"
    fi
}

clean_ami
clean_snapshot
build_rundeckv1_ami
