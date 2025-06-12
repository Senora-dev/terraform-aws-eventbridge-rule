variable "create_rule" {
  description = "Whether to create the EventBridge rule"
  type        = bool
  default     = true
}

variable "create_target" {
  description = "Whether to create the EventBridge target"
  type        = bool
  default     = true
}

variable "rule_name" {
  description = "The name of the EventBridge rule"
  type        = string
}

variable "rule_description" {
  description = "The description of the EventBridge rule"
  type        = string
  default     = null
}

variable "schedule_expression" {
  description = "The scheduling expression for the rule"
  type        = string
  default     = null
}

variable "event_pattern" {
  description = "The event pattern for the rule"
  type        = string
  default     = null
}

variable "rule_role_arn" {
  description = "The ARN of the IAM role associated with the rule"
  type        = string
  default     = null
}

variable "is_enabled" {
  description = "Whether the rule is enabled"
  type        = bool
  default     = true
}

variable "targets" {
  description = "Map of EventBridge targets"
  type = map(object({
    arn            = string
    role_arn       = optional(string)
    input          = optional(string)
    input_path     = optional(string)
    input_transformer = optional(object({
      input_paths    = map(string)
      input_template = string
    }))
    run_command_targets = optional(list(object({
      key    = string
      values = list(string)
    })))
    ecs_target = optional(object({
      task_definition_arn = string
      launch_type         = optional(string)
      platform_version    = optional(string)
      group               = optional(string)
      network_configuration = optional(object({
        subnets          = list(string)
        security_groups  = optional(list(string))
        assign_public_ip = optional(bool)
      }))
    }))
    batch_target = optional(object({
      job_definition = string
      job_name       = string
      array_size     = optional(number)
      job_attempts   = optional(number)
    }))
    kinesis_target = optional(object({
      partition_key_path = string
    }))
    sqs_target = optional(object({
      message_group_id = string
    }))
    http_target = optional(object({
      path_parameter_values    = optional(list(string))
      query_string_parameters  = optional(map(string))
      header_parameters        = optional(map(string))
    }))
    dead_letter_config = optional(object({
      arn = string
    }))
    retry_policy = optional(object({
      maximum_event_age_in_seconds = optional(number)
      maximum_retry_attempts       = optional(number)
    }))
  }))
  default = {}
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
} 