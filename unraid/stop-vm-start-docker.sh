#!/bin/bash

VM_NAME="Fairbanks1"
DOCKER_CONTAINER_NAME="tdarr_node"

# Stop the VM if running
if virsh list --name --state-running | grep -q "^$VM_NAME$"; then
    echo "$VM_NAME is already running."
else
    # If not running, start the VM
    virsh stop "$VM_NAME"
    echo "Stopping $VM_NAME..."
fi

# Wait 30 secs for the VM to shutdown
sleep 30

# Start the docker container
if docker inspect --format '{{.State.Running}}' "$DOCKER_CONTAINER_NAME" 2>/dev/null | grep -iq "true"; then
    echo "$DOCKER_CONTAINER_NAME is already running."
else
    # If not running, start the Docker container
    docker start "$DOCKER_CONTAINER_NAME"
    echo "Starting $DOCKER_CONTAINER_NAME..."
fi