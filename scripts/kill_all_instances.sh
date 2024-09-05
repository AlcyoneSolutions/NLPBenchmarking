# Will stop all instances linked to this user.
CURRENT_USER=$(gcloud config get-value account)
ALL_INSTANCES=$(gcloud compute instances list --filter="serviceAccounts[0].email=$CURRENT_USER AND status=RUNNING" --format=json)

# Check if empty. (Return [] if empty)
if [ "$ALL_INSTANCES" == "[]" ]; then
  # Show in yellow escape sequence
  echo -e "\033[0;33mNo instances found. Exiting.\033[0m"
  exit 0
else
  # Lets kill all instances
  for row in $(echo "${ALL_INSTANCES}" | jq -r '.[] | @base64'); do
      _jq() {
       echo ${row} | base64 --decode | jq -r ${1}
      }

     INSTANCE=$(_jq '.name')
     ZONE=$(_jq '.zone')  # This returns  "https://www.googleapis.com/compute/v1/projects/<project_name>/zones/<desired_zone>"
     # CHECK: I am unsure this is robust enough. Might fail if url is not in the format above
     ZONE=$(echo $ZONE | cut -d "/" -f 9)

     METADATA=$(_jq '.metadata')
     # Ensure that creator is the same as the current user
     if [ "$(echo $METADATA | yq '.items[0].value' | grep $CURRENT_USER)" == "" ]; then
       continue
     fi

     # Ask for confirmation
     read -p "Are you sure you want to stop $INSTANCE at $ZONE? [y/N]: " CONFIRM
     echo -e "\033[0m"
     if [ "$CONFIRM" != "y" ]; then
       echo "Exiting. If you want to change this variable, please set them as envvars before running this script."
       continue
     fi
     gcloud compute instances stop $INSTANCE --zone=$ZONE
     # Check if returns an error
     if [ $? -ne 0 ]; then
       # Use red escape sequence to print in red
       echo -e "\033[0;31mStopping $INSTANCE at $ZONE failed. ❌\033[0m"
       exit 1
     else
       # Use green escape sequence to print in green
       echo -e "\033[0;32mStopping $INSTANCE at $ZONE succeeded. ✅\033[0m"
     fi
        
  done
fi


