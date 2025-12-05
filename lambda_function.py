import urllib3
import json
import boto3

sns = boto3.client("sns")
TOPIC_ARN = "arn:aws:sns:us-east-1:216989099527:uptime-monitor-alerts"  

def lambda_handler(event, context):
    http = urllib3.PoolManager()
    url = "https//google.com"  # change later

    try:
        response = http.request("GET", url)
        status_code = response.status

        if status_code == 200:
            return {
                "statusCode": 200,
                "body": json.dumps("Website is UP")
            }
        else:
            # notify SNS
            sns.publish(
                TopicArn=TOPIC_ARN,
                Message="Website returned non-200 response!"
            )
            return {
                "statusCode": status_code,
                "body": json.dumps("Alert sent: Non-200 detected")
            }

    except Exception:
        sns.publish(
            TopicArn=TOPIC_ARN,
            Message="Website is DOWN or unreachable!"
        )
        return {
            "statusCode": 500,
            "body": json.dumps("Alert sent: unreachable website")
        }
