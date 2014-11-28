#!/bin/bash

# Pulls stable FFMPEG docker container, pulls stable command scripts, and builds & runs the docker container for SBC
# placed in /usr/local/bin to run manually if needed.  It is started by an Upstart script at reboots.

# Environment
DIR="/home/ubuntu"

sudo docker rm $(sudo docker ps -aq)
sudo docker pull nachochip/ffmpeg:stable
cd ${DIR} && \
	wget -N https://github.com/nachochip/sbc/archive/stable.tar.gz && \
	tar xzvf stable.tar.gz && \
	cd *stable* && \
	sudo docker build -t localbuild/sbc:latest . && \
        sudo docker build -t localbuild/sbc:$(date +"%Y%m%d-%Hh%Mm") .
sudo docker run localbuild/sbc:latest
                # Consider running this as a separate Upstart, that way it can be respawned and monitored with that -a tag!!
                # https://docs.docker.com/articles/host_integration/

##  Temp item to get test ready
#mkdir /www
#wget -P /www https://dl.dropboxusercontent.com/u/14528072/bjput-delete.mp4
#sudo docker run -v /www:/www localbuild/sbc:latest

