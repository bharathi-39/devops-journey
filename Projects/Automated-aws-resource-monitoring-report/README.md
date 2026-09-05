# Automated AWS Resource Monitoring and Reporting using Shell Scripting & Cron

## Project Overview

This project automates the collection of AWS resource information using AWS CLI commands, Bash scripting, and Linux Cron.

The script collects information from multiple AWS services and stores the output in a log file automatically at scheduled intervals.

---

## Technologies Used

- Linux (Ubuntu EC2)
- Bash Shell Scripting
- AWS CLI
- Cron Scheduler
- IAM
- S3
- Lambda
- EC2
- jq

---

## Problem Statement

Manually checking AWS resources repeatedly is time-consuming.

The goal of this project was to automate the collection of AWS infrastructure details and generate reports automatically.

---

## Solution

A shell script was created to collect:

- S3 Bucket Details
- Lambda Function Details
- EC2 Instance Details
- IAM Users

The script was then scheduled using Cron to execute every minute and generate reports automatically.

---

## Script Location

```bash
/home/ubuntu/project1.sh
