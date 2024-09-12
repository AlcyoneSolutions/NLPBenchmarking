# Will create a new instance based on the container that we have here.
# Ask for name of instance
ZONE="asia-east1-c"
MACHINE_TYPE="e2-standard-4"
# TODO: Pull this from .venv and purge this.
CONTAINER_IMAGE="asia-east1-docker.pkg.dev/optical-loop-431606-m6/kb-registry/nlp-benchmarks:0.1.2"
DISK_SIZE="200" # GB
USER=$(gcloud config get-value account)
TAGS="benchmarking-env,http-server,https-server"
METADATA="gce-container-image=$CONTAINER_IMAGE"
METADATA="$METADATA,creator=$USER"

echo -e "\033[0;33m"
read -p "Please enter the name of the instance: " INSTANCE_NAME
echo -e "\033[0m"
# Show current constants to user and ask for confirmation.
echo -e "\033[0;33mThe following constants will be used:\033[0m"
echo -e "\033[0;33m- Zone: $ZONE\033[0m"
echo -e "\033[0;33m- Machine Type: $MACHINE_TYPE\033[0m"
echo -e "\033[0;33m- Container Image: $CONTAINER_IMAGE\033[0m"
echo -e "\033[0;33m- Disk Size: $DISK_SIZE\033[0m"
echo -e "\033[0;33m- Instance Name: $INSTANCE_NAME\033[0m"
echo -e "\033[0;33m"
read -p "Are you sure you want to continue? [y/N]: " CONFIRM
echo -e "\033[0m"
if [ "$CONFIRM" != "y" ]; then
    echo "Exiting. If you want to change this variable, please set them as envvars before running this script."
    exit 1
fi

gcloud compute instances create-with-container \
    $INSTANCE_NAME \
    --zone=$ZONE \
    --machine-type=$MACHINE_TYPE \
    --container-image=$CONTAINER_IMAGE \
    --tags=$TAGS \
    --metadata=$METADATA \
    --boot-disk-size=$DISK_SIZE \
    --container-arg="--publish=8888:8888"
    --container-arg="--publish=42022:42022"

if [ $? -ne 0 ]; then
  echo -e "\033[0;31m ❌ Instance $INSTANCE_NAME failed to create\033[0m"
else
  echo -e "\033[0;33m ✅ Instance $INSTANCE_NAME creation command successful\033[0m".

  # Now we need to see if we can keep synchronizing the results here.
fi
