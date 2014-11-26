#!/bin/bash

# This script is to be included in setting up an AMI on ec2.  You will need to manually save the AMI as the new version.

#install pip and asw-cli
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

# pull in the "stable" version of the Upstart and shell scripts, so they can automatically run on reboots
DIR=$(mktemp -d) && \
	cd ${DIR} && \
	wget https://github.com/nachochip/sbc-ec2-create-build/archive/stable.tar.gz && \
	tar xzvf stable.tar.gz && \
	cd *stable* && \
	mv mySBCupstart.conf /etc/init/ && \
	mv initializeSBC.sh /usr/local/bin/ && \
	rm -rf ${DIR}
# if you need to start the service, add this
#service mySBCupstart.conf start
