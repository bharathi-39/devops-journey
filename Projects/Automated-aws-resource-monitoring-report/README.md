# Automated AWS Resource Monitoring and Reporting

## Project Overview

This project automates AWS resource monitoring using:

- Linux
- Shell Scripting
- AWS CLI
- Cron Jobs

Resources Monitored:

- S3 Buckets
- Lambda Functions
- EC2 Instances
- IAM Users

## Script Location

/home/ubuntu/project1.sh

## Log Location

/home/ubuntu/logfiles/aws_daily_report.log

## Cron Configuration

* * * * * /home/ubuntu/project1.sh >> /home/ubuntu/logfiles/aws_daily_report.log 2>&1

## Technologies Used

- Linux
- Bash
- AWS CLI
- Cron
- EC2
- S3
- Lambda
- IAM
- jq

## Learning Outcomes

- AWS CLI
- Linux Automation
- Shell Scripting
- Log Management
- Cron Scheduling
