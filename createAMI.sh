#!/bin/bash

# This script is to be included in setting up an AMI on ec2
# It will setup the environment.  Then you will need to manually save the AMI as the new version.

apt-get update && apt-get dist-upgrade -y
apt-get install -y tmux iperf iptraf iotop htop

# Consider adding in the script for making sure ec2 Enahanced Networking works.....postpone for now until everything is up and running.

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

# pull in the "stable" version of the Upstart or cron scripts, so they can automatically run on reboots

RUN DIR=$(mktemp -d) && cd ${DIR} && \
	wget https://github.com/nachochip/sbc-ec2-create-build/archive/stable.tar.gz && \
	tar xzvf stable.tar.gz && \
	cd *stable* && \
#####NOW INSERT COMMANDS TO MOVE UPSTART COMMANDS TO PROPER LOCATION on ec2 instance
	mv my*.conf /etc/init/
	rm -rf ${DIR}
