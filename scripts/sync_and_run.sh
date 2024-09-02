#!/bin/bash

LOCAL_ROOT_DIR=$(pwd)
EXCLUE_ARRY=( "data" "logs" "notebooks" "resources" "scripts" "windows_requirements.txt" "Makefile" ".gitignore" ".dockerignore" "docker-compose.yml" "Dockerfile" "README.md" "LICENSE" )
EXCLUDE_STRING=$(printf ",%s" "${EXCLUE_ARRY[@]}")
# First parameter is the python command to run remotely
REMOTE_COMMAND=$1


# Sync the repo to the remote
rsync -av --exclude=".git" --exclude="data/" --exclude="logs/" --exclude="notebooks/" --exclude="resources/" --exclude="scripts/" --exclude="windows_requirements.txt" --exclude="Makefile" --exclude=".gitignore" --exclude=".dockerignore" --exclude="docker-compose.yml" --exclude="Dockerfile" --exclude="README.md" --exclude="LICENSE" ./ $USER@$HOST:/home/$USER/nlpbench

# ssh into the remote
ssh $USER@$HOST

# Run the docker container
docker run -it --rm -v $LOCAL_ROOT_DIR:/opt/nlpbench nlpbench:latest
