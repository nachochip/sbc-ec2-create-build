#!/bin/bash

# This script is to be included in setting up an ENCODING server AMI on ec2.  You will need to manually save the AMI as the new version.

apt-get update && apt-get dist-upgrade -y
apt-get install -y tmux iperf iptraf iotop htop ca-certificates wget

#################################
# Install latest Docker via PPA
# This part is from http://get.docker.com/ubuntu
# Due to future updates, I have opted to wget their script

wget -qO- https://get.docker.com/ | sh

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

# technically, I should only be registering the new conf file once it is in the correct folder location
initctl reload-configuration

# Force a reboot, so all my configuration files kick in correctly
reboot

# I NEED TO MOUNT THE TEMP EPHEMERAL DRIVES AND MOUNT LOGS TO IT
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!1start here and use a small spot instance to learn the commands to put here, then push, and start a better instance.


#?Do you want to write to s3 for log storage or piping video over for recording.(add awscli and pip)
# Consider adding in the script for making sure ec2 Enahanced Networking works.....postpone for now until everything is up and running.

# I will have to make one more script to detect (via aws internal commands[see email link] & aws-cli] active region/instance-id from within
# 	and add (vs attach ENI) a private ip address for ffmpeg to work internally and deliver to wowza correctly.
# I will also need to create ffmpeg on campus (via aws cli, iam-user) to detect active region/instance-id/public-ip so it can deliver stream.
# If a region is changed, the address needs to be added to cloudfront.....create a 2nd cloudfront for these times, program via aws-cli on campus
# 	to command an addition/deployment of the wowza public ip to cloudfront (will deploy in 15 minutes).
# In website, ?multiple cloudfront m3u8 will likely fallback as needed on links, but ?will flash-hls? downgrade to working link?
# 	Consider using "playlist" in swf code.? (if not, will need to use aws-cli here too, to modify/deploy to current cloudfront?).
