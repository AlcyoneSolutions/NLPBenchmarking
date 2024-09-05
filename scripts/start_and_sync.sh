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
echo ":: Looking fo instances for user $CURRENT_USER"

# TOREM: b4 production
AVAILABLE_INSTANCES=$(gcloud compute instances list --filter="serviceAccounts[0].email=$CURRENT_USER AND status=TERMINATED" --format=json)
INSTANCE_NAMES_AND_METADATA=$(echo "$AVAILABLE_INSTANCES" | jq -r '.[] | select(.metadata.items[].key == "gce-container-declaration") | {name, metadata: .metadata.items[0].value}')

# Base64 to get nice rows
# INSTANCE_NAMES_AND_METADATA=$(cat instances.json | jq -r '.[] | select(.metadata.items[].key == "gce-container-declaration") | {name, metadata: .metadata.items[0].value} | @base64')
# echo "$INSTANCE_NAMES_AND_METADATA" > IN_ME.json
# Propmpt Choice to user
echo "::The following instances are available to you:"

# Organize Data Neatly with Escape Codes into a single row
# row_strings = ()
declare -a row_strings

# CHECK: Why the need of base64 encoding
for row in $(echo "${INSTANCE_NAMES_AND_METADATA}"); do

    echo "Processing ${row}"
    # When we have the information in .
    ROW_NAME=$(echo "${row}" | base64 --decode | jq -r ".name")

    # NOTE: This usues unofficial API so it might not work for long.
    # If something breaks and you dont know why this is a good place to look into. 
    ## Metadata is in TOML format. We need to procure spec.containers.image
    _row_metadata=$(echo "${row}" | jq -r ".metadata")

    IMAGE_NAME = $(echo "${_row_metadata}" | toml get spec.containers.image)

    # Lets organize it pretty. Well tabed and the like lets pass it to a program to show tabularity
    # sh -c "echo -e \"$ROW_NAME\t$IMAGE_NAME\""

done

echo -e "\033[0;33mPlease select one to use:\033[0m"
PS3="Select instance: "
exit
select INSTANCE in $all_names; do
    echo "You selected $INSTANCE"
    gcloud compute instances start $INSTANCE --zone=$ZONE
    break
done

echo -e "\033[0;33mPlease select one to use:\033[0m"
PS3="Select instance: "
select INSTANCE in $AVAILABLE_INSTANCES; do
    echo "You selected $INSTANCE"
    gcloud compute instances start $INSTANCE --zone=$ZONE
    break
done

