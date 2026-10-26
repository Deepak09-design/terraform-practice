
# Lambda execution role
resource "aws_iam_role" "lambda_role" {
  name = "day9-scheduled-lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Allow Lambda to write CloudWatch logs
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda function
resource "aws_lambda_function" "scheduled_lambda" {
  function_name = "day9-scheduled-lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"

  filename         = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")

  timeout     = 10
  memory_size = 128

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs
  ]
}

# EventBridge Scheduler execution role
resource "aws_iam_role" "scheduler_role" {
  name = "day9-eventbridge-scheduler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Principal = {
        Service = "scheduler.amazonaws.com"
      }
    }]
  })
}

# Permit Scheduler to invoke this Lambda only
resource "aws_iam_role_policy" "scheduler_invoke_lambda" {
  name = "day9-scheduler-invoke-lambda"
  role = aws_iam_role.scheduler_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "lambda:InvokeFunction"
      Resource = aws_lambda_function.scheduled_lambda.arn
    }]
  })
}

# Run Lambda every 5 minutes
resource "aws_scheduler_schedule" "lambda_schedule" {
  name        = "day9-lambda-every-five-minutes"
  description = "Invoke Day 9 Lambda every five minutes"
  state       = "ENABLED"

  schedule_expression          = "rate(5 minutes)"
  schedule_expression_timezone = "UTC"

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = aws_lambda_function.scheduled_lambda.arn
    role_arn = aws_iam_role.scheduler_role.arn

    input = jsonencode({
      source = "eventbridge-scheduler"
      task   = "scheduled-execution"
    })

    retry_policy {
      maximum_event_age_in_seconds = 3600
      maximum_retry_attempts       = 2
    }
  }

  depends_on = [
    aws_iam_role_policy.scheduler_invoke_lambda
  ]
}

# Display the Lambda function name
output "lambda_function_name" {
  value = aws_lambda_function.scheduled_lambda.function_name
}

# Display the schedule expression
output "schedule_expression" {
  value = aws_scheduler_schedule.lambda_schedule.schedule_expression
}
