#!/bin/bash

if [ "$1" == "--disable" ] || [ "$1" == "-d" ]
then
    echo "Disabling the swapfile..."
    sudo swapoff -v /swapfile
    sudo rm /swapfile
else
    sudo fallocate -l 1G /swapfile
    sudo dd if=/dev/zero of=/swapfile bs=1024 count=1048576
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    sudo swapon --show
    sed -e 's/$/ /swapfile swap swap defaults 0 0'
    sudo sysctl vm.swappiness=10
fi