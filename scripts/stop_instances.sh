# Will stop all instances linked to this user.
CURRENT_USER=$(gcloud config get-value account)
echo "Stopping all instances started by $CURRENT_USER"
ALL_INSTANCES=$(gcloud compute instances list --filter="serviceAccounts[0].email=$CURRENT_USER" --format=json)
# echo $ALL_INSTANCES
for row in $(echo "${ALL_INSTANCES}" | jq -r '.[] | @base64'); do
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }

   INSTANCE=$(_jq '.name')
   ZONE=$(_jq '.zone')

   echo "Stopping $INSTANCE at $ZONE"
   # gcloud compute instances stop $INSTANCE --zone=$ZONE
done
