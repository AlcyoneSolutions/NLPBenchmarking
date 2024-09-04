#!/bin/bash

# USER Constants
CONTAIMER_TAG="asia-east1-docker.pk.dev/optical-loop-431606-m6/kb-reistry/barebones1 "

# Constants
LOCAL_ROOT_DIR=$(pwd)
EXCLUE_ARRY=( "data" "logs" "notebooks" "resources" "scripts" "windows_requirements.txt" "Makefile" ".gitignore" ".dockerignore" "docker-compose.yml" "Dockerfile" "README.md" "LICENSE" )
EXCLUDE_STRING=$(printf ",%s" "${EXCLUE_ARRY[@]}")
# First parameter is the python command to run remotely
REMOTE_COMMAND=$0

# Remote data
CURRENT_USER=$(gcloud config get-value account)
# Get non-running instances
echo ":: Looking for instances for user $CURRENT_USER"
AVAILABLE_INSTANCES=$(gcloud compute instances list --filter="serviceAccounts[0].email=$CURRENT_USER AND status=TERMINATED" --format=json)
INSTANCE_NAMES_AND_METADATA=$(echo "$AVAILABLE_INSTANCES" | jq -r '.[] | select(.metadata.items[].key == "gce-container-declaration") | {.name, .metadata.items[0].value} | @base64')
# Propmpt Choice to user
echo "The following instances are available to you:"
echo "$INSTANCE_NAMES_AND_METADATA"

declare -a _rows

for row in $(echo "${INSTANCE_NAMES_AND_METADATA}" | jq -r '.[] | @base64'); do
  name = $(echo $row | base64 --decode | jq -r '.name')
  zone = $(echo $row | base64 --decode | jq -r '.zone')
  container_image_name = $(echo $row | base64 --decode | jq -r '.containerImageName


# Output the titles.

exit 0
echo -e "\033[0;33mPlease select one to use:\033[0m"
PS3="Select instance: "
select INSTANCE in $AVAILABLE_INSTANCES; do
    echo "You selected $INSTANCE"
    gcloud compute instances start $INSTANCE --zone=$ZONE
    break
done

