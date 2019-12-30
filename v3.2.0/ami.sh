#!/bin/bash

function clean_ami () {
    clear
    echo -e "~~~~~ Removing previous AMI and related files... ~~~~~\n"
    
    # Remove RUNDECKV3_AMI_ID.log if it exists.
    cat packer/logs/RUNDECKV3_AMI_ID.log > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        previous_RUNDECKV3_AMI=$(cat packer/logs/RUNDECKV3_AMI_ID.log)
        aws ec2 deregister-image --image-id $previous_RUNDECKV3_AMI --region us-east-1
        rm packer/logs/RUNDECKV3_AMI_ID.log
    else
        echo -e "No File Named RUNDECKV3_AMI_ID.log found, skipping step."
    fi
    
    # Remove the rundeckv3_ami_output.log if it exists.
    cat packer/logs/rundeckv3_ami_output.log > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        rm packer/logs/rundeckv3_ami_output.log
    else
        echo -e "No File Named rundeckv3_ami_output.log found, skipping step.\n"
    fi
    
    > terraform/variables.tf
}

function build_rundeckv3_ami () {
    echo -e "\n ~~~~~ Validating RunDeckv3 Packer Template ~~~~~ \n"
    rundeckv3_Valid=$(packer validate packer/rundeck-v3.2.0.json)
    
    if [[ $rundeckv3_Valid == "Template validated successfully." ]]; then
        echo -e "RunDeckv3 Template validated successfully"
        echo -e "\nBuilding RunDeckv3 AMI...\n"
        packer build -color=false packer/rundeck-v3.2.0.json | tee packer/logs/rundeckv3_ami_output.log
        rundeckv3PreExportVar=$(cat packer/logs/rundeckv3_ami_output.log | tail -n 2 \
            | sed '$ d' \
            | sed "s/us-east-1: /variable "\"packer_built_rundeckv3_ami"\" { default = \"/" \
        | sed -e 's/[[:space:]]*$/\"/')
        rundeckv3ExportVar="${rundeckv3PreExportVar} }"
        echo $rundeckv3ExportVar >> terraform/variables.tf
        # Print last two lines of the build logs | Match all cases for 'ami-*' | get the 2md column of the line using a space as delimiter.
        RUNDECKV3_AMI_ID=$(tail -2 packer/logs/rundeckv3_ami_output.log | grep 'ami-[a0-z9]*' | cut -d " " -f 2)
        if [[ $RUNDECKV3_AMI_ID == "" ]]; then
            echo -e "Errors occurred while building the RunDeckv3 Packer Image, please check the logs."
        else
            echo $RUNDECKV3_AMI_ID > packer/logs/RUNDECKV3_AMI_ID.log
            echo
        fi
    else
        echo -e "RunDeckv3 Packer Template is not valid!"
    fi
}

clean_ami
build_rundeckv3_ami
