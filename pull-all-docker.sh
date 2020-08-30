#!/bin/sh

if [ -z "$1" ]
  then echo "Error: Please specify a Dockerhub user"
  exit
fi

echo "Dockerhub User: $1\n\n"

IMAGES=$(curl https://registry.hub.docker.com/v2/repositories/$1/ --silent | jq -r '.results | .[] | .name')

for i in $IMAGES
do
  echo "Pulling all tags for image: $1/$i"
  docker pull $1/$i --all-tags --quiet > /dev/null 2>&1
  docker images | grep $i | tr -s ' ' | cut -d ' ' -f 2 | xargs -I {} docker rmi $1/$i:{} > /dev/null 2>&1
  echo "Cleaned up pulled images for: $1/$i\n"
done

echo "[OK] All Docker images have been pulled for $1"