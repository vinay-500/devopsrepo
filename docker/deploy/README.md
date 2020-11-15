## Builds the server into docker

Builds and uploads to repo

`-l Libraries`

`-s Source folder where appup-core is there. It should be in /libs only later.`

```
./deploy.sh -l /appup_lib/ -s /Users/manohar/Documents/workspace/appup-2020/appup-core-repo/target -v 0.1
```

## Builds and uploads to repo

Everything in above docker PLUS

`-r repo`

`-a access keys`

`-k key`

```
./deploy.sh -l /appup_lib/ -s /Users/manohar/Documents/workspace/appup-2020/appup-core-repo/target -v 0.1 -r 101933413708.dkr.ecr.us-east-2.amazonaws.com/appup -a AKIARPO5UOVGNOZMZ7UV -k u6WXQuS++cd9fY8Jgb0MV+C5FNVegSB84xqMj6b8
```

## Start the server locally after build

```
docker rm -f server; docker run -it --name=server -e CLOUD_ID=3679 -e SVC_NAME=g appup-server:0.1 /bin/bash
```
