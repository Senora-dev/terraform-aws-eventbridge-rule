locals {
  create_rule = var.create_rule
  create_target = var.create_target
}

# EventBridge Rule
resource "aws_cloudwatch_event_rule" "this" {
  count = local.create_rule ? 1 : 0

  name                = var.rule_name
  description         = var.rule_description
  schedule_expression = var.schedule_expression
  event_pattern       = var.event_pattern
  role_arn           = var.rule_role_arn
  state              = var.is_enabled ? "ENABLED" : "DISABLED"

  tags = var.tags
}

# EventBridge Target
resource "aws_cloudwatch_event_target" "this" {
  for_each = local.create_target ? var.targets : {}

  rule           = aws_cloudwatch_event_rule.this[0].name
  target_id      = each.key
  arn            = each.value.arn
  role_arn       = lookup(each.value, "role_arn", null)
  input          = lookup(each.value, "input", null)
  input_path     = lookup(each.value, "input_path", null)

  dynamic "input_transformer" {
    for_each = lookup(each.value, "input_transformer", null) != null ? [each.value.input_transformer] : []
    content {
      input_paths    = input_transformer.value.input_paths
      input_template = input_transformer.value.input_template
    }
  }

  dynamic "run_command_targets" {
    for_each = lookup(each.value, "run_command_targets", null) != null ? each.value.run_command_targets : []
    content {
      key    = run_command_targets.value.key
      values = run_command_targets.value.values
    }
  }

  dynamic "ecs_target" {
    for_each = lookup(each.value, "ecs_target", null) != null ? [each.value.ecs_target] : []
    content {
      task_definition_arn = ecs_target.value.task_definition_arn
      launch_type         = lookup(ecs_target.value, "launch_type", null)
      platform_version    = lookup(ecs_target.value, "platform_version", null)
      group               = lookup(ecs_target.value, "group", null)
      network_configuration {
        subnets          = lookup(ecs_target.value.network_configuration, "subnets", [])
        security_groups  = lookup(ecs_target.value.network_configuration, "security_groups", [])
        assign_public_ip = lookup(ecs_target.value.network_configuration, "assign_public_ip", false)
      }
    }
  }

  dynamic "batch_target" {
    for_each = lookup(each.value, "batch_target", null) != null ? [each.value.batch_target] : []
    content {
      job_definition = batch_target.value.job_definition
      job_name       = batch_target.value.job_name
      array_size     = lookup(batch_target.value, "array_size", null)
      job_attempts   = lookup(batch_target.value, "job_attempts", null)
    }
  }

  dynamic "kinesis_target" {
    for_each = lookup(each.value, "kinesis_target", null) != null ? [each.value.kinesis_target] : []
    content {
      partition_key_path = kinesis_target.value.partition_key_path
    }
  }

  dynamic "sqs_target" {
    for_each = lookup(each.value, "sqs_target", null) != null ? [each.value.sqs_target] : []
    content {
      message_group_id = sqs_target.value.message_group_id
    }
  }

  dynamic "http_target" {
    for_each = lookup(each.value, "http_target", null) != null ? [each.value.http_target] : []
    content {
      path_parameter_values = lookup(http_target.value, "path_parameter_values", null)
      query_string_parameters = lookup(http_target.value, "query_string_parameters", null)
      header_parameters = lookup(http_target.value, "header_parameters", null)
    }
  }

  dynamic "dead_letter_config" {
    for_each = lookup(each.value, "dead_letter_config", null) != null ? [each.value.dead_letter_config] : []
    content {
      arn = dead_letter_config.value.arn
    }
  }

  dynamic "retry_policy" {
    for_each = lookup(each.value, "retry_policy", null) != null ? [each.value.retry_policy] : []
    content {
      maximum_event_age_in_seconds = lookup(retry_policy.value, "maximum_event_age_in_seconds", null)
      maximum_retry_attempts       = lookup(retry_policy.value, "maximum_retry_attempts", null)
    }
  }
} 