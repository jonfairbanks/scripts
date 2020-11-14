#!/bin/sh
docker stop factorio
docker rm factorio
docker pull jonfairbanks/docker_factorio_server
docker run -d -p 34197:34197/udp -p 27015:27015/tcp -v /home/$USER/Docker/factorio:/factorio --name factorio --restart=always jonfairbanks/docker_factorio_server