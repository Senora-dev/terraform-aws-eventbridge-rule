output "rule_arn" {
  description = "The ARN of the EventBridge rule"
  value       = try(aws_cloudwatch_event_rule.this[0].arn, null)
}

output "rule_name" {
  description = "The name of the EventBridge rule"
  value       = try(aws_cloudwatch_event_rule.this[0].name, null)
}

output "rule_id" {
  description = "The ID of the EventBridge rule"
  value       = try(aws_cloudwatch_event_rule.this[0].id, null)
}

output "target_ids" {
  description = "The IDs of the EventBridge targets"
  value       = { for k, v in aws_cloudwatch_event_target.this : k => v.id }
}

output "target_arns" {
  description = "The ARNs of the EventBridge targets"
  value       = { for k, v in aws_cloudwatch_event_target.this : k => v.arn }
} 