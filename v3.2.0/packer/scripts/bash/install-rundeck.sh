#!/bin/bash -x

# -e  Exit immediately if a command exits with a non-zero status.
set -e

git clone https://github.com/rundeck/docker-zoo.git
cd docker-zoo/cloud

mkdir libext
cd libext
wget https://github.com/rundeck-plugins/rundeck-s3-log-plugin/releases/download/v1.0.5/rundeck-s3-log-plugin-1.0.5.jar

cd ..

cat >> .env <<EOL
## Set pro options if applicable
# RUNDECK_IMAGE=rundeckpro/team:SNAPSHOT
# RUNDECK_LICENSE_FILE=

AWS_CREDENTIALS=
RUNDECK_PLUGIN_EXECUTIONFILESTORAGE_S3_BUCKET=
RUNDECK_PLUGIN_EXECUTIONFILESTORAGE_S3_REGION=
RUNDECK_STORAGE_PASSWORD=admin
EOL