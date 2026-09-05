
# Project Screenshots

This folder contains screenshots captured during the development and testing of the Automated AWS Resource Monitoring and Reporting project.

---

## 1. Script Execution

**File:**

```text
script-output.png
```

Description:

This screenshot shows the successful execution of the Bash script (`project1.sh`) that collects information from AWS services using AWS CLI commands.

Resources collected:

- Amazon S3 Buckets
- AWS Lambda Functions
- Amazon EC2 Instances
- AWS IAM Users

---

## 2. Cron Job Configuration

**File:**

```text
cron-job.png
```

Description:

This screenshot shows the cron configuration used to automate the execution of the shell script.

Cron Entry:

```bash
* * * * * /home/ubuntu/project1.sh >> /home/ubuntu/logfiles/aws_daily_report.log 2>&1
```

The script runs every minute and appends the generated report to a log file.

---

## 3. Generated Log Report

**File:**

```text
aws-report-log.png
```

Description:

This screenshot displays the generated report stored in:

```text
/home/ubuntu/logfiles/aws_daily_report.log
```

The log contains:

- AWS resource information
