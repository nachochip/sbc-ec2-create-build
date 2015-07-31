#!/bin/bash

# This script is to be included in setting up an ENCODING server AMI on ec2.  You will need to manually save the AMI as the new version.

apt-get update && apt-get dist-upgrade -y
apt-get install -y tmux iperf iptraf iotop htop wget

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
	wget -N https://www.github.com/nachochip/sbc-ec2-create-build/archive/stable.tar.gz && \
	tar xzvf stable.tar.gz && \
	cd *stable* && \
	mv upstartinitializeencoder.conf /etc/init/ && \
	mv initializeencoder.sh /usr/local/bin/ && \
	rm -rf ${DIR}
#Try without this
#service upstartinitializeencoder start

# technically, I should only be registering the new conf file once it is in the correct folder location
initctl reload-configuration

#?install pip and aswcli if I want to write to s3 for log storage or piping video over for recording.
# Consider adding in the script for making sure ec2 Enahanced Networking works.....postpone for now until everything is up and running.

# I will have to make one more script to detect (via aws internal commands[see email link] & aws-cli] active region/instance-id from within
# 	and add (vs attach ENI) a private ip address for ffmpeg to work internally and deliver to wowza correctly.
# I will also need to create ffmpeg on campus (via aws cli, iam-user) to detect active region/instance-id/public-ip so it can deliver stream.
# If a region is changed, the address needs to be added to cloudfront.....create a 2nd cloudfront for these times, program via aws-cli on campus
# 	to command an addition/deployment of the wowza public ip to cloudfront (will deploy in 15 minutes).
# In website, ?multiple cloudfront m3u8 will likely fallback as needed on links, but ?will flash-hls? downgrade to working link?
# 	Consider using "playlist" in swf code.? (if not, will need to use aws-cli here too, to modify/deploy to current cloudfront?).
