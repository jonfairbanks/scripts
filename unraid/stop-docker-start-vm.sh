#!/bin/bash

DOCKER_CONTAINER_NAME="tdarr_node"
VM_NAME="Fairbanks1"

# Stop the docker container
if docker inspect --format '{{.State.Running}}' "$DOCKER_CONTAINER_NAME" 2>/dev/null | grep -iq "true"; then
     # If running, stop the Docker container
    docker stop "$DOCKER_CONTAINER_NAME"
    echo "Stopping $DOCKER_CONTAINER_NAME..."
else
    echo "$DOCKER_CONTAINER_NAME is not running."
fi

# Wait 30 secs for the container to shutdown
sleep 30

# Stop the VM if running
if virsh list --name --state-running | grep -q "^$VM_NAME$"; then
    echo "$VM_NAME is already running."
else
    # If not running, start the VM
    virsh start "$VM_NAME"
    echo "Stopping $VM_NAME..."
fi