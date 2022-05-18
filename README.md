# terraform-sqs-plus-dlq-notification

This module will provision a main sqs and a dead letter queue which will trigger cloudwatch notification when a new messages arrives.


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.65.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_sqs_queue.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/aws_sqs_queue) | resource |
| [aws_sqs_queue_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/aws_sqs_queue_policy) | resource |
| [aws_sqs_queue.this_dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/aws_sqs_queue) | resource |
| [aws_sqs_queue_policy.this_dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/aws_sqs_queue_policy) | resource |
|[aws_sns_topic.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/aws_sns_topic) | resource |
|[aws_sns_topic_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/aws_sns_topic_subscription) | resource |
|[aws_cloudwatch_metric_alarm.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/aws_cloudwatch_metric_alarm) | resource |
|[aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/aws_iam_policy_document) | data source |
|[aws_iam_policy_document.this_dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/aws_iam_policy_document) | data source |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="sqs_name"></a> [sqs\_name](#sqs\_name) | Name of the queue | `string` | n/a | yes |
| <a name="extra_tags"></a> [extra\_tags](#iextra\_tags) | Extra tags for the created resources | `map(string)` | n/a | no |
| <a name="roles_arn"></a> [roles\_arn](#roles\_arn) | roles arn that will get access to the queue | `list(string)` | n/a | yes |
| <a name="delay_seconds"></a> [delay\_seconds](#delay\_seconds) | sqs delay in seconds | `number` | 30 | no |
| <a name="max_message_size"></a> [max\_message\_size](#max\_message\_size) | max size of the message in bytes | `number` | 2048 | no |
| <a name="message_retention_seconds"></a> [message\_retention\_seconds](#message\_retention\_seconds) | message retention | `number` | 1209600 | no |
| <a name="receive_wait_time_seconds"></a> [receive\_wait_time\_seconds](#receive\_wait\_time_seconds) | message receive delay | `number` | 2 | no |
| <a name="dlq_delay_seconds"></a> [dlq\_delay\_seconds](#dlq\_delay\_seconds) | sqs delay in seconds | `number` | 30 | no |
| <a name="dlq_max_message_size"></a> [dlq\_max\_message\_size](#dlq\_max\_message\_size) | max size of the message in bytes | `number` | 2048 | no |
| <a name="dlq_message_retention_seconds"></a> [dlq\_message\_retention\_seconds](#dlq\_message\_retention\_seconds) | message retention | `number` | 1209600 | no |
| <a name="dlq_receive_wait_time_seconds"></a> [dlq\_receive\_wait_time\_seconds](#dlq\_receive\_wait\_time_seconds) | message receive delay | `number` | 2 | no |
| <a name="dlq_roles_arn"></a> [dlq\_roles\_arn](#roles\_arn) | roles arn that will get access to the to the dead letter queue | `list(string)` | n/a | yes |
| <a name="sns_topic_name"></a> [sns\_topic\_name](#sns\_topic\_name) | Topic name | `string` | `"dlq_notification"` | no |
| <a name="protocol"></a> [protocol](#protocol) | Topic protocol | `string` | `"email"` | no |
| <a name="endpoint"></a> [endpoint](#endpoint) | Endpoint protocol | `string` | `"email"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="sqs_url"></a> [sqs\_url](#output\_sqs_\url) | Queue URL |
| <a name="sqs_dlq_url"></a> [sqs\_dlq\_url](#output\_sqs_\dlq\_url) | Queue URL |
