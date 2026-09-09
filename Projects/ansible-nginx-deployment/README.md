# Ansible Nginx Deployment on AWS EC2

## Project Overview

This project demonstrates how to use Ansible to automate
web server deployment on AWS EC2 instances.

## Architecture

Controller EC2
      |
      | SSH
      |
Target EC2

## Technologies Used

- AWS EC2
- Ubuntu Linux
- Ansible
- SSH
- Nginx

## Steps Performed

1. Created Controller and Target EC2
2. Configured SSH key authentication
3. Created Ansible Inventory
4. Tested Connectivity using Ansible Ping
5. Installed Nginx using Ansible
6. Deployed Custom Web Page

## Verification

Access the target server public IP and verify the custom webpage.

## Learning Outcomes

- Infrastructure Automation
- Configuration Management
- SSH Authentication
- Ansible Adhoc Commands
- Service Management
