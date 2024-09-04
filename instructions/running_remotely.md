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

# Running Locally

You can run the same environment I used to build this by running:

```
nix develop
```

Once you run this command you will be thrown into a new shell with all the piece of software necessary to run this program from scratch. Thats it, all dependency fetching for both python and otherwise has been done for you automatically.

This will download all of the dependencies both for python and extraneous pieces of software necessary for running all of this.
If you dont feel like working with nix you can always take a look at the section(s) within the `flake.nix` detailing the dependencies.
If you do that, however, you are on your own. 


## Post

Once in your shiny new shell. We will proceed to initialize a gcloud environment:

```sh
gcloud init
```

Select the project that corresponds to this directory.

You can now run all commands listed under the `Makefile`.

# Of Note
- Pay particular attention to which Google Compute Engince (GCE) "zone" you are connecting to. 
As you may have different resources with the same be hosted in different areas! You may incur ~stupid~ hidden costs.

# Some Useful Commands

## GCloud

- List all instances running within a certain project.:

```sh
gcloud compute instances list
```
