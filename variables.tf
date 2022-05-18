variable "sqs_name" {
  description = "name of the queue"
  type        = string
}

variable "extra_tags" {
  description = "extra tags for all the resources"
  type        = map(string)
}

variable "delay_seconds" {
  type        = number
  default     = 30
  description = "sqs delay in seconds"
}

variable "max_message_size" {
  type        = number
  default     = 2048
  description = "max size of the message in bytes"
}

variable "message_retention_seconds" {
  type        = number
  default     = 1209600
  description = "message retention"
}

variable "receive_wait_time_seconds" {
  type        = number
  default     = 2
  description = "message receive delay"
}

variable "roles_arn" {
  description = "roles arn that will get access to the queue"
  type        = list(string)
}

variable "dlq_delay_seconds" {
  type        = number
  default     = 30
  description = "sqs delay in seconds"
}

variable "dlq_max_message_size" {
  type        = number
  default     = 2048
  description = "max size of the message in bytes"
}

variable "dlq_message_retention_seconds" {
  type        = number
  default     = 1209600
  description = "message retention"
}

variable "dlq_receive_wait_time_seconds" {
  type        = number
  default     = 2
  description = "message receive delay"
}

variable "dlq_roles_arn" {
  description = "roles arn that will get access to the queue"
  type        = list(string)
}

variable "sns_topic_name" {
  description = "topic name"
  default     = "dlq_notification"
  type        = string
}

variable "protocol" {
  description = "topic protocol, default is email"
  type        = string
  default     = "email"
}

variable "endpoint" {
  description = "endpoint protocol"
  type        = string
}
