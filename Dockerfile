# Building Docker Image and integrating SBC scripts
# this will be a local build

FROM nachochip/ffmpeg:stable

MAINTAINER 	Nachochip 	<blockchaincolony@gmail.com>

ADD 	04addthisto03.sh 	/usr/local/bin/

#CMD           	["04addthisto03.sh"]
#ENTRYPOINT 	["bash"]
