#!/bin/bash

##################################
#Author: Bharathi Ganesh S
#Date: 5th September 2026
#Version : V1
#Project Name: Automated AWS resources Data Collection Report
##################################

#To Note the command used while executing
set -x

#S3 Bucket data list
echo "Bucket data list"
aws s3 ls

#Lamda Function list
echo "Lambda Functio list"
aws lambda list-functions
#ooo
#EC2 Instances list
echo "EC2 Instances list"
aws ec2 describe-instances |jq '.Reservations[].Instances[].InstanceId'

#List IAM users
echo "IAM user list"
aws iam list-users

