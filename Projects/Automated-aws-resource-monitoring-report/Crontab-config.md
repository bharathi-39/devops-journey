# Cron Configuration

## Purpose

Cron automatically executes the AWS resource reporting script and appends its output to a log file.

## Paths

Script:

```text
/home/ubuntu/project1.sh
```

Log directory:

```text
/home/ubuntu/logfiles
```

Log file:

```text
/home/ubuntu/logfiles/aws_daily_report.log
```

## Preparation

Create the log directory:

```bash
mkdir -p /home/ubuntu/logfiles
```

Make the script executable:

```bash
chmod 755 /home/ubuntu/project1.sh
```

Test the script manually:

```bash
/home/ubuntu/project1.sh
```

Test logging manually:

```bash
/home/ubuntu/project1.sh >> /home/ubuntu/logfiles/aws_daily_report.log 2>&1
```

Confirm that the log was created:

```bash
ls -l /home/ubuntu/logfiles
cat /home/ubuntu/logfiles/aws_daily_report.log
```

## Create the Cron Job

Open the current user's crontab:

```bash
crontab -e
```

### Run Every Minute

```cron
* * * * * /home/ubuntu/project1.sh >> /home/ubuntu/logfiles/aws_daily_report.log 2>&1
```

### Run Every 10 Minutes

```cron
*/10 * * * * /home/ubuntu/project1.sh >> /home/ubuntu/logfiles/aws_daily_report.log 2>&1
```

### Run Daily at 9:00 AM

```cron
0 9 * * * /home/ubuntu/project1.sh >> /home/ubuntu/logfiles/aws_daily_report.log 2>&1
```

## Cron Field Format

```text
minute hour day-of-month month day-of-week command
```

```text
* * * * *
| | | | |
| | | | +-- Day of week: 0-7
| | | +---- Month: 1-12
| | +------ Day of month: 1-31
| +-------- Hour: 0-23
+---------- Minute: 0-59
```

## Redirection

```bash
>> /home/ubuntu/logfiles/aws_daily_report.log
```

Appends standard output to the report file.

```bash
2>&1
```

Redirects standard error to the same location as standard output.

The order matters. In this entry:

```cron
command >> report.log 2>&1
```

stdout is first redirected to `report.log`, and stderr is then redirected to the current stdout destination.

## Verify the Configuration

List cron jobs:

```bash
crontab -l
```

Check the cron service:

```bash
systemctl status cron --no-pager
```

Check cron activity on Ubuntu:

```bash
sudo journalctl -u cron --no-pager
```

Or:

```bash
grep CRON /var/log/syslog
```

Check the report:

```bash
tail -n 100 /home/ubuntu/logfiles/aws_daily_report.log
```

## Troubleshooting

### Log File Is Not Created

1. Confirm the directory exists.
2. Confirm the cron entry is saved with `crontab -l`.
3. Manually run the exact command from the cron entry.
4. Confirm the cron service is active.
5. Check cron service logs.

### AWS Command Not Found

Cron has a limited environment. Find the executable paths:

```bash
command -v aws
command -v jq
```

If required, replace `aws` and `jq` in the script with their absolute paths, for example `/usr/local/bin/aws` and `/usr/bin/jq`, based on the output from the server.

### AWS Authentication Error

Verify the active identity:

```bash
aws sts get-caller-identity
```

For an EC2-hosted automation project, an IAM role attached to the instance is preferable to long-term access keys stored on disk.

### Pager Opens With `(END)`

The script includes:

```bash
export AWS_PAGER=""
```

This prevents the AWS CLI from opening long responses in a pager during an automated run.

## Production Note

Running every minute can grow the log quickly. A longer interval and log rotation are better for ongoing use. The one-minute schedule is suitable for demonstrating and testing the automation.
