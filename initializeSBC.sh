#!/bin/bash

# Pulls stable FFMPEG docker container, pulls stable command scripts, and builds & creates the docker container for SBC.
# Placed in /usr/local/bin to run manually if needed.  This script is started by an Upstart script at reboots.

# Environment variable
DIR="/home/ubuntu"

sudo docker rm $(sudo docker ps -aq)
sudo docker pull nachochip/ffmpeg:stable
cd ${DIR} && \
	wget -N https://github.com/nachochip/sbc/archive/stable.tar.gz && \
	tar xzvf stable.tar.gz && \
	cd *stable* && \
	sudo docker build -t localbuild/sbc:latest . && \
        sudo docker build -t localbuild/sbc:$(date +"%Y%m%d-%Hh%Mm") .
sudo docker create --name="multiencoder" localbuild/sbc:latest
