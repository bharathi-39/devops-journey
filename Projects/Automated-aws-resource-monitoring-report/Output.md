## Script Execution


+ echo 'S3 bucket list'
S3 bucket list
+ aws s3 ls
2026-09-05 09:32:14 bharathi-s3-bucket1
2026-09-05 09:32:41 bharathi-s3-bucket2

+ echo 'Lambda function list'
Lambda function list
+ aws lambda list-functions
{
    "Functions": [
        {
            "FunctionName": "bharathi-sample2-lambdafuncion",
            "Runtime": "nodejs24.x",
            "Handler": "index.handler",
            "PackageType": "Zip"
        },
        {
            "FunctionName": "bharathi-sample1-lambdafuncion",
            "Runtime": "nodejs24.x",
            "Handler": "index.handler",
            "PackageType": "Zip"
        }
    ]
}

+ echo 'EC2 instance ID list'
EC2 instance ID list
+ aws ec2 describe-instances
+ jq -r '.Reservations[].Instances[].InstanceId'
i-082ec5a3d812225b3

+ echo 'IAM user list'
IAM user list
+ aws iam list-users
{
    "Users": [
        {
            "Path": "/",
            "UserName": "Bharathi_Admin"
        }
    ]
}

+ date
Report completed at: Sat Sep 5 09:50:05 UTC 2026
```

## Cron-Generated Log

The cron entry appends every execution to:

```text
/home/ubuntu/logfiles/aws_daily_report.log
```

View the complete log:

```bash
cat /home/ubuntu/logfiles/aws_daily_report.log
```

View the latest 50 lines:

```bash
tail -n 50 /home/ubuntu/logfiles/aws_daily_report.log
```

Monitor new entries:

```bash
tail -f /home/ubuntu/logfiles/aws_daily_report.log
```

## Important Note

Do not upload the complete raw report without reviewing it. AWS CLI output may contain AWS account IDs, ARNs, IAM user names, role names, resource names, and other environment-specific data.
