#!/bin/bash

# Special note: the streaming software will not allow EBS instances, so this will control the streaming server.
# a simple 4GB volume is all that is needed

apt-get update && apt-get dist-upgrade -y
apt-get install -y tmux iperf iptraf iotop htop ca-certificates wget

# Consider adding in the script for making sure ec2 Enahanced Networking works.....postpone for now until everything is up and running.

# install pip and awscli, making sure it is latest version
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py
pip install awscli
pip install --upgrade awscli

# pull in the upstart script and configuration files
DIR=$(mktemp -d) && \
        cd ${DIR} && \
        wget -N https://www.github.com/nachochip/sbc-ec2-create-build/archive/stable.tar.gz && \
        tar xzvf stable.tar.gz && \
        cd *stable* && \
        mv upstartinitializestreaming.conf /etc/init/ && \
        mv upstartuninitializestreaming.conf /etc/init/ && \
        mv initializestreaming.sh /usr/local/bin/ && \
        mv uninitializestreaming.sh /usr/local/bin/ && \
        rm -rf ${DIR}

# technically, I should only be registering the new conf file once it is in the correct folder location,
initctl reload-configuration

# Force a reboot, so all my configuration files kick in correctly
reboot
