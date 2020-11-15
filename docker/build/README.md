# Build Container

Compiles Appup and uploads to server
https://docs.google.com/document/d/110P7jKg9n-OVjd1iunyHzViN7sttLwd_zDyIvFukoqM/edit#

## Process

Goes to each folder, runs maven run (if error bail)
Compiles and puts the jar files into /appup-lib folder
Builds the docker based on the files and core appup jar file
Uploads the docker to appup docker repo

## Command

Only builds locally

> give the source
> maven cache (optional)
> output where you want it to build (if upload is also there, leave it as it will create it from scratch)

```
docker run -it -v ~/Documents/workspace/appup-2020:/appup-src -v /Users/manohar/.m2:/root/.m2 -v /appup_libs:/appup_libs appup-build:0.1
```

Builds and deploys it if REPO is found

```
docker run -it -v ~/Documents/workspace/appup-2020:/appup-src -v /Users/manohar/.m2:/root/.m2 -v /appup_libs:/appup_libs -e REPO=101933413708.dkr.ecr.us-east-2.amazonaws.com/appup VER=0.1 -e ACCESS_KEY=AKIARPO5UOVGNOZMZ7UV -e SECRET_KEY=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 appup-build:0.1
```
