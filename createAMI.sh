#!/bin/bash

# This script is to be included in setting up an AMI on ec2
# It will setup the environment.  Then you will need to manually save the AMI as the new version.

# Environment Variables,  DISABLED FOR NOW
#DOCKERVER="1.3.1"

# Basic update/upgrade
apt-get update && apt-get dist-upgrade -y

# Install any version of following
apt-get install -y git tmux iperf iptraf iotop htop

#################################
# Install latest Docker via PPA
# This part is from http://get.docker.com/ubuntu

# Check that HTTPS transport is available to APT
if [ ! -e /usr/lib/apt/methods/https ]; then
	apt-get update
	apt-get install -y apt-transport-https
fi

# Add the repository to your APT sources
echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list

# Then import the repository key
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9

# Install docker
apt-get update
apt-get install -y lxc-docker
#################################

# Setup and upstart or cron scripts, so they can automatically run on reboots
#####currently working on this part
