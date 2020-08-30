#!/bin/sh

curl https://registry.hub.docker.com/v2/repositories/$1/ --silent | jq '.results'