#!/bin/bash

# This script removes all instances of wowza upon the shutdown of the controlling instance

# Environment variable
DIR="/home/ubuntu"

export AWS_DEFAULT_REGION=us-east-1

aws ec2 terminate-instances --instance-ids \
        $(aws ec2 describe-instances --filters "Name=product-code.type,Values=devpay" \
                --output text | awk -F"\t" '$1=="INSTANCES" {print $8}n')

# outer terminate-instances using the ID
# inner recall the id, perhaps just write to file
