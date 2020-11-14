#!/bin/sh
set -x
sudo apt-get clean
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y autoremove
pihole -up
