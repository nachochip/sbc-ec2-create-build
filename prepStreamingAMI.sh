#!/bin/bash

# This script is to be included in setting up a streaming server AMI on ec2.  You will need to manually save the AMI as the new version.
# after this, do the manual steps to install the streming binary.  Wish we can get some automation for this.

#install pip and asw-cli?
apt-get update && apt-get dist-upgrade -y
apt-get install -y tmux iperf iptraf iotop htop

# Consider adding in the script for making sure ec2 Enahanced Networking works.....postpone for now until everything is up and running.

# Install Java JDK
# insert commands here
