# Will initialize the environmetn in the shellHook

## Check if we have all the necessary environment variables

# First check for the .gpg files. Decrypt them all in place
LIST_OF_GPG_FILES=$(find . -name "*.gpg")
# Decrypt them all in place
for file in $LIST_OF_GPG_FILES; do
    name_without_gpg=$(echo $file | sed 's/\.gpg//g')
    if [ -f "$name_without_gpg" ]; then
      echo "Decrypting $file to $name_without_gpg"
      gpg --decrypt $file > $name_without_gpg
    fi
done

gcloud auth activate-service-account --key-file=service_account.json &> /dev/null
export ACCOUNT_NAME=$(gcloud config get-value account)

