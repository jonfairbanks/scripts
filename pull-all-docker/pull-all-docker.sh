#!/bin/sh

PIDS=""
RESULT=0
USER=""
IMAGES=""

if [ -z "$1" ]
  then 
    echo "Error: Please specify a Docker Hub user"
    exit 1
else
  USER=$1
  IMAGES=$(curl https://registry.hub.docker.com/v2/repositories/$1/ --silent | jq -r '.results | .[] | .name')
  echo "Pulling images/tags for Docker Hub user: $USER\n"
fi

pull_and_clean() {
  docker pull $USER/$i --all-tags --quiet > /dev/null 2>&1
  docker images | grep $i | tr -s ' ' | cut -d ' ' -f 2 | xargs -I {} docker rmi $USER/$i:{} > /dev/null 2>&1
  echo "Pulled all tags for image: $USER/$i"
}

for i in $IMAGES
do
  pull_and_clean $i &
  PIDS="$PIDS $!"
done

for pid in $PIDS; do
  wait $pid || let "RESULT=1"
done

if [ "$RESULT" -eq 1 ];
  then
    exit 1
fi