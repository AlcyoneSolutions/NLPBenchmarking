# How to Run Remotely
## Ensuring no dangling remote instances.

Run gcloud to ask which instances are currently running:
```sh
gcloud compute instances list --format="table(name,zone,machineType,status,networkInterfaces[0].networkIP,networkInterfaces[0].accessConfigs[0].natIP)"
```
or 

```
gcloud 
```

