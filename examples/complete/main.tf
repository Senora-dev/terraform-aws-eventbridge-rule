provider "aws" {
  region = "us-west-2"
}

# Create a Lambda function
resource "aws_lambda_function" "example" {
  filename         = "lambda_function.zip"
  function_name    = "example-function"
  role            = aws_iam_role.lambda.arn
  handler         = "index.handler"
  runtime         = "nodejs18.x"

  tags = local.tags
}

# Create an SQS queue
resource "aws_sqs_queue" "example" {
  name = "example-queue"
  
  tags = local.tags
}

# Create an SNS topic
resource "aws_sns_topic" "example" {
  name = "example-topic"
  
  tags = local.tags
}

# Create a dead-letter queue
resource "aws_sqs_queue" "dlq" {
  name = "example-dlq"
  
  tags = local.tags
}

# Create IAM role for Lambda
resource "aws_iam_role" "lambda" {
  name = "example-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

  tags = local.tags
}

# Create IAM role for EventBridge
resource "aws_iam_role" "eventbridge" {
  name = "example-eventbridge-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "events.amazonaws.com"
      }
    }]
  })

  tags = local.tags
}

# Create EventBridge rule
module "eventbridge_rule" {
  source = "../../"

  create_rule   = true
  create_target = true

  rule_name          = "example-complete-rule"
  rule_description   = "Example EventBridge rule with multiple targets"
  schedule_expression = "rate(5 minutes)"
  is_enabled         = true
  rule_role_arn      = aws_iam_role.eventbridge.arn

  targets = {
    lambda = {
      arn = aws_lambda_function.example.arn
      input = jsonencode({
        key = "value"
      })
      retry_policy = {
        maximum_event_age_in_seconds = 60
        maximum_retry_attempts       = 3
      }
    }
    sns = {
      arn = aws_sns_topic.example.arn
      input_transformer = {
        input_paths = {
          time   = "$.time"
          detail = "$.detail"
        }
        input_template = "\"At <time>, the status was <detail>\""
      }
    }
    sqs = {
      arn = aws_sqs_queue.example.arn
      dead_letter_config = {
        arn = aws_sqs_queue.dlq.arn
      }
    }
  }

  tags = {
    Environment = "prod"
    Project     = "example"
  }
}

# Locals
locals {
  tags = {
    Environment = "prod"
    Project     = "example"
  }
} 