#A SQS Queue for API Sign Commands and Parameters / DOPS-107
#tfsec:ignore:aws-sqs-enable-queue-encryption
resource "aws_sqs_queue" "this" {
  name                      = var.sqs_name
  delay_seconds             = var.delay_seconds
  max_message_size          = var.max_message_size
  message_retention_seconds = var.max_message_size
  receive_wait_time_seconds = var.receive_wait_time_seconds
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.this_dlq.arn
    maxReceiveCount     = 3
  })
  tags = merge(
    {
      "Name"                 = var.sqs_name
      "penneo:resource:name" = var.sqs_name
    },
    var.extra_tags
  )
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"
    actions = [
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:ReceiveMessage",
      "sqs:SendMessage",
      "sqs:ChangeMessageVisibility"
    ]
    principals {
      identifiers = var.roles_arn
      type        = "AWS"
    }
    resources = [
      aws_sqs_queue.this.arn,
    ]
  }
}
resource "aws_sqs_queue_policy" "this" {
  queue_url = aws_sqs_queue.this.id
  policy    = data.aws_iam_policy_document.this.json
}

#tsec:ignore:aws-sqs-enable-queue-encryption
#SQS dead letter queue
#This queue can be used by all other queue in the account as a dead letter queue
#tfsec:ignore:aws-sqs-enable-queue-encryption
resource "aws_sqs_queue" "this_dlq" {
  name                      = "${var.sqs_name}-dlq"
  delay_seconds             = var.dlq_delay_seconds
  max_message_size          = var.dlq_max_message_size
  message_retention_seconds = var.dlq_message_retention_seconds
  receive_wait_time_seconds = var.dlq_receive_wait_time_seconds
  redrive_allow_policy = jsonencode({
    redrivePermission = "allowAll"
  })

  tags = merge(
    {
      "Name"                 = "${var.sqs_name}-dlq"
      "penneo:resource:name" = "${var.sqs_name}-dlq"
    },
    var.extra_tags
  )
}

data "aws_iam_policy_document" "this_dlq" {
  statement {
    effect = "Allow"
    actions = [
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:ReceiveMessage",
      "sqs:SendMessage",
      "sqs:ChangeMessageVisibility"
    ]
    principals {
      identifiers = var.dlq_roles_arn
      type        = "AWS"
    }
    resources = [
      aws_sqs_queue.this_dlq.arn
    ]
  }
}
resource "aws_sqs_queue_policy" "this_dlq" {
  queue_url = aws_sqs_queue.this_dlq.id
  policy    = data.aws_iam_policy_document.this_dlq.json
}

#SNS
resource "aws_sns_topic" "this" {
  name            = "${var.sqs_name}-sns-topic"
  tags            = var.extra_tags
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
}

# This adds a SQS subscriber to the sunit release topic, to push the events.
resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = var.protocol
  endpoint  = var.endpoint
}

#Cloudwatch - dead letter queue alarm
#Got it from here https://stackoverflow.com/questions/60211243/configure-sqs-dead-letter-queue-to-raise-a-cloud-watch-alarm-on-receiving-a-mess
resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name                = "${var.sqs_name}_dlq_message_in_queue"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  threshold                 = "0"
  alarm_description         = "desc"
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.this.arn]

  metric_query {
    id          = "e1"
    expression  = "RATE(m2+m1)"
    label       = "Error Rate"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "ApproximateNumberOfMessagesVisible"
      namespace   = "AWS/SQS"
      period      = "60"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        QueueName = "${aws_sqs_queue.this_dlq.name}"
      }
    }
  }

  metric_query {
    id = "m2"

    metric {
      metric_name = "ApproximateNumberOfMessagesNotVisible"
      namespace   = "AWS/SQS"
      period      = "60"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        QueueName = "${aws_sqs_queue.this_dlq.name}"
      }
    }
  }
}