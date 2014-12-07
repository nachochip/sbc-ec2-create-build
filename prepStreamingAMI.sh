#!/bin/bash

# This script is to be included in setting up a STREAMING server AMI on ec2.  You will need to manually save the AMI as the new version.
# After this, do the manual steps to install the streaming binary.  Wish we can get some automation for this.
# ?  which ami?just re-use there ami and setup for myself.  change to yum?
apt-get update && apt-get dist-upgrade -y
apt-get install -y tmux iperf iptraf iotop htop ca-certificates


# Install Java JDK
# insert commands here

# next are the manual steps for the streaming server



#install pip and aswcli?
# Consider adding in the script for making sure ec2 Enahanced Networking works.....postpone for now until everything is up and running.
