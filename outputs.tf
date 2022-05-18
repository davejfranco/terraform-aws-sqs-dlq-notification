output "sqs_url" {
  value = aws_sqs_queue.this.url
}

output "sqs_dlq_url" {
  value = aws_sqs_queue.this_dlq.url
}