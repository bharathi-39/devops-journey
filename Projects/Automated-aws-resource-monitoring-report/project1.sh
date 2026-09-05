#!/bin/bash

###################################
#Author: Bharathi Ganesh S
#Date: 5th September 2026
#Version: V1
#Project Name: Automated AWS Resources Data Collection Report
###################################

set -x
#List the bucket
echo "Bucket data list"
aws s3 ls

#List the lambda functions
echo "Lambda Function list"
aws lambda list-functions

#List the EC2 instances
echo "EC2 Instances list"
aws ec2 describe-instances | jq '.Reservations[].Instances[].InstanceId'

#List the available I am users
echo "IAM user list"
aws iam list-users
