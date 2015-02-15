#!/bin/bash

# This script will start an instance of wowza, places inside VPC, and configures it to run
# These commands require the instance to be run via AWS IAM role credentials for high security

# Environment variable
DIR="/home/ubuntu"

# pull in latest stable live.zip file
cd ${DIR} && \
        wget -N https://github.com/nachochip/sbc-ec2-create-build/archive/stable.tar.gz && \
        tar xzvf stable.tar.gz && \
        cd *stable* && \

# start wowza instance
######### For Other instances go to DEVPAY versions  =  http://www.wowza.com/forums/content.php?23-pre-built-amis-(amazon-machine-images)
######### To calculate size of instance go to http://www.wowza.com/resources/WowzaMediaServerForEC2_UsersGuide.pdf
####### WOWZA Versions	AMI ID
####### ver. 3.0.5    	ami-deba68b7	**	deprecated
####### ver. 3.1.0    	ami-29924a40	**	never tried
####### ver. 3.1.2	ami-3e79db57	** 	deprecated
####### ver. 3.5.2.01 	ami-8cfd6de5    ***** 	used this one, and it worked well
####### ver. 4.0.1    	ami-f50e0f9c    ** 	didn't work, glitch every 1-3 seconds, pixels were messed up
####### ver. 4.0.3.01 	ami-3dc2d954    **      never tried
####### ver. 4.0.6    	ami-f6a5789e	**	never tried
####### ver. 4.1.0v2  	ami-98fd4ef0	*****   most recent working one
######                  SIZES
######    m1.small, m1.medium,  m1.large  - currently using m1.large due to new software and cloudfront usage
######				I was wanting to build an AMI to be able to put onto newer instance types......they
######					do NOT allow EBS usage on instances with the DEVPAY system
######	http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#using-regions-availability-zones-describe
######  	 REGIONS	ZONES		  LOCATION
######  	us-east-1	a,b,c,d		North Virginia		*** 	our main region
######  	us-west-1	b,c		Northern California	**	backup region (program under construction)
######  	us-west-2	a,b		Oregon			*	2nd backup region (program under construction)
######  	eu-west-1	a,b,c		Ireland
######  	sa-east-1	a,b		Sao Paulo, Brazil
######   	ap-northeast-1	a,b		Tokyo, Japan
######   	ap-southeast-1	a,b		Singapore
######
### Load Averages, in linux, under 'top'/'htop' command, they are 1 min, 5 min, and 15 min load averages.  Consider the
###   number of cores you have, so 1 core @ load of 1.00 is fully used, and 4 core @ 2.00 is 50% used.

# connect ip address / virtual network interface  ---  place above command inside parenthesis with cut/sed stuff
# create this as an interactive data value, which is needed for the command below

# currently using m1.large, DEVPAY will not let me use m3 instance types....krazy
# the opsworks default subnet is drawing from the us-east-1d zone
export AWS_DEFAULT_REGION=us-east-1

aws ec2 associate-address --instance-id \
        $(export InstanceIDValue=$(aws ec2 run-instances --image-id ami-98fd4ef0 --count 1 --security-group-ids sg-72d0211a \
                --key-name CFC --user-data fileb://live.zip --instance-type m1.large \
                --placement AvailabilityZone=us-east-1d --output text | awk -F"\t" '$1=="INSTANCES" {print $8}n')\
                ; sleep 15; echo $InstanceIDValue) \
        --public-ip 23.21.227.80

#  HMMMM, IDEA = run above "run-instances" command, then pipe the output to the associate-address command
# in case above doesn't work, you will need to break it out with this command, or use the old method of printing to files
# aws ec2 describe-instances --filters "Name=product-code.type,Values=devpay"

# AWS CLI REFERENCE
# http://docs.aws.amazon.com/cli/latest/reference/ec2/index.html
