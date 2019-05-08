### Introduction

This script is a simple example to show how masking can be automated using Scripts and Actifio.   


The sequence of events are intended for a liveclone workflow:

1)  A LiveClone of the source database is refreshed from the lastest snapshot
2)  This LiveClone is prep-mounted to a masking host where the source database is prep-mounted as a new database with a different name
The workflow needs to ensure the prep-mounted DB has that name or the launcher script will fail.
3)  The workflow calls the launcher.sh as a post mount task (after the prepmount). This starts a second script or process.
If that script o process fails the prep-mount fails.
4)  Once the masking is complete, the prep-mount is unmounted and the liveclone is now in a masked state.
5)  The masked liveClone is now mounted to the target host as a new database by the workflow.

This means the workflow needs to be setup as follows:

* Workflow Type:  Liveclone
* Schedule Type:  On Demand
* Mount for Pre-Processing:  On
* Post-Script:  launcher.sh   (or whatever the .sh file is called)
* Create New Virtual Application:  On
* Oracle Database Name (SID):  Should match the DB name in the masking.sh script  

On the next panel you can set it up any way you like,  if the database is called dmdb, then ideally use this:

* Source DB name:      dmdb
* Prepmount DB name:   prepdmdb 
* Final mount DB name: maskdmdb

### Validation

Compare the masked data between the source DB and the mounted masked copy .

### Important details to be aware of

1)  The masking section of the launcher shell script only runs when these are all set:   "%ACT_MULTI_OPNAME%" == "scrub-mount" if "%ACT_MULTI_END%" == "true" if "%ACT_PHASE%" == "post" 

This ensures the script only runs after all parts of the prep-mount are complete including mounting of logs and starting of prepmounted Database.

### Manual test of launcher file

You can also run the launcher.sh file with a parameter of 'test' to do a manual set of masking.

### What is masking.sh

Masking.sh is a simple and trivial masking script that can be used to demontrate masking without masking software.

### Other Software Launcher files
The point of this GIT repository is to share a framework that lets you test masking without masking software.  In addition are some working examples of scripts that run masking software.   These scripts are not complete in that the setup of the masking software is not described.

#### What is camolauncher.sh ?

So camolauncher.sh is exactly the same as launcher.sh except that instead of running a shell script that does shell script masking, it instead starts Camouflage software to do masking instead.   Note this calls for a file called /home/oracle/Mask-Demo.camo    This file would be created when you set up your masking routine with Camouflage.

#### What is optimlauncher.sh ?

So optimlauncher.sh s exactly the same as launcher.sh except that instead of running a shell script that does shell script masking, it instead starts IBM Optim software to do masking instead, on a database called optimdb.  There are optim files called by the tasks being run by this script, that need to be created using Optim Software.
