# IAM Role and Policy for Lambda Execution
resource "aws_iam_role" "lambda_role" {
  name = "uptime-monitor-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_iam_policy" "lambda_policy" {
  name = "uptime-monitor-lambda-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "sns:Publish"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "lambda_role_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Lambda Function for Uptime Monitoring 
resource "aws_lambda_function" "uptime_lambda" {
  function_name = "uptime-monitor-function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  filename         = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")
}

# CloudWatch Event Rule to Trigger Lambda Every 5 Minutes
resource "aws_cloudwatch_event_rule" "uptime_schedule" {
  name        = "uptime-monitor-schedule"
  description = "Triggers uptime Lambda every 5 minutes"
  schedule_expression = "rate(5 minutes)"
}
# Permission for CloudWatch to Invoke Lambda
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.uptime_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.uptime_schedule.arn
}
# CloudWatch Event Target to Link Rule to Lambda
resource "aws_cloudwatch_event_target" "uptime_target" {
  rule      = aws_cloudwatch_event_rule.uptime_schedule.name
  target_id = "UptimeMonitorLambda"
  arn       = aws_lambda_function.uptime_lambda.arn
}

# SNS Topic for Uptime Alerts
resource "aws_sns_topic" "uptime_alerts" {
  name = "uptime-monitor-alerts"
}

# Subscribe Email to SNS Topic
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.uptime_alerts.arn
  protocol  = "email"
  endpoint  = "qamar.ayaz777@gmail.com"
}