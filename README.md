# AWS EventBridge Rule Terraform Module

This Terraform module creates an AWS EventBridge (CloudWatch Events) rule and its associated targets.

## Features

- Create EventBridge rules with schedule expressions or event patterns
- Support for multiple target types:
  - Lambda functions
  - SQS queues
  - SNS topics
  - ECS tasks
  - Batch jobs
  - Kinesis streams
  - HTTP endpoints
  - Systems Manager Run Command
- Configurable retry policies and dead-letter queues
- Support for input transformers
- Tagging support

## Usage

```hcl
module "eventbridge_rule" {
  source = "path/to/module"

  rule_name        = "my-scheduled-rule"
  schedule_expression = "rate(5 minutes)"
  
  targets = {
    lambda = {
      arn = "arn:aws:lambda:region:account:function:my-function"
      input = jsonencode({
        key = "value"
      })
    }
    
    sqs = {
      arn = "arn:aws:sqs:region:account:my-queue"
      sqs_target = {
        message_group_id = "group1"
      }
    }
  }

  tags = {
    Environment = "prod"
    Project     = "my-project"
  }
}
```

## Examples

- [Basic Example](examples/basic/main.tf) - Creates a simple scheduled rule with a Lambda target
- [Complete Example](examples/complete/main.tf) - Creates a rule with multiple targets and advanced configurations

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_rule | Whether to create the EventBridge rule | `bool` | `true` | no |
| create_target | Whether to create the EventBridge target | `bool` | `true` | no |
| rule_name | The name of the EventBridge rule | `string` | n/a | yes |
| rule_description | The description of the EventBridge rule | `string` | `null` | no |
| schedule_expression | The scheduling expression for the rule | `string` | `null` | no |
| event_pattern | The event pattern for the rule | `string` | `null` | no |
| rule_role_arn | The ARN of the IAM role associated with the rule | `string` | `null` | no |
| is_enabled | Whether the rule is enabled | `bool` | `true` | no |
| targets | Map of EventBridge targets | `map(object)` | `{}` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| rule_arn | The ARN of the EventBridge rule |
| rule_name | The name of the EventBridge rule |
| rule_id | The ID of the EventBridge rule |
| target_ids | The IDs of the EventBridge targets |
| target_arns | The ARNs of the EventBridge targets |

## License

MIT Licensed. See LICENSE for full details.

## Maintainers

This module is maintained by [Senora.dev](https://senora.dev). 