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

# Create EventBridge rule
module "eventbridge_rule" {
  source = "../../"

  rule_name        = "example-scheduled-rule"
  schedule_expression = "rate(5 minutes)"
  
  targets = {
    lambda = {
      arn = aws_lambda_function.example.arn
      input = jsonencode({
        key = "value"
      })
    }
  }

  tags = local.tags
}

# Locals
locals {
  tags = {
    Environment = "dev"
    Project     = "example"
  }
} 