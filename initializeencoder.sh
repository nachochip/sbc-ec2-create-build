#!/bin/bash

# Pulls stable FFMPEG docker container, pulls stable command scripts, and builds & creates the docker container for SBC.
# Placed in /usr/local/bin to run manually if needed.  This script is started by an Upstart script at reboots.

# Environment variable
DIR="/home/ubuntu"
#### ?? perhaps use a whoami to insert a sudo if I am manually calling this script....and if upstart needs
#### no sudo, then I can remove here so upstart can trigger correctly on reboots
# ?? do I need sudo when started by upstart vs manually starting it?? or is the issue with upstart??
docker rm -f $(docker ps -aq)
docker pull nachochip/ffmpeg:stable

cd ${DIR} && \
	wget -N https://www.github.com/nachochip/sbc/archive/stable.tar.gz && \
	tar xzvf stable.tar.gz && \

# add afile to base dir for the special stream
# if the file is absent, run the standard way
# if it is present, run the new way
if [ ! -f ${DIR}/afile ] ;
	then
		cd *stable* && \
		docker build -t localbuild/sbc:latest . && \
	else
		cd *stable*/yourstreamlive && \
		docker build -t localbuild/sbc:latest . && \
	fi

#Disabled since I don't review builds right now
#docker build -t localbuild/sbc:$(date +"%Y%m%d-%Hh%Mm") .

# there is now a force option in docker 1.4.0 for names/tags
docker create --name="multiencoder" localbuild/sbc:latest
