#!/bin/bash

#run a Docker image with local volume

# modify this to include stuff to simulate ec2 "building base install scripts for required software" (inside createAMI.sh)
sudo docker run -v $HOME/projects/docker/KEEP-ec2-sbc-encoder-base-image-20141117:/www -v $HOME/projects/docker/KEEP-sbc-ffmpeg-scripts-20141113:/root -it --privileged jpetazzo/dind bash


# put the cron/init scripts part here (inside ?)

