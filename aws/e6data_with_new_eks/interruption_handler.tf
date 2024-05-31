#https://karpenter.sh/docs/reference/cloudformation/#interruption-handling
# Create an SQS queue to handle node interruption messages for Karpenter
resource "aws_sqs_queue" "node_interruption_queue" {
  name                      = "e6data-${local.short_workspace_name}-spot-interruption-queue"
  sqs_managed_sse_enabled = true
  message_retention_seconds = 300
}

# Create an IAM policy document allowing specific AWS services to send messages to the SQS queue
data "aws_iam_policy_document" "sqs_access_policy_doc" {
  statement {
    sid    = "First"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com", "sqs.amazonaws.com"]
    }

    actions = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.node_interruption_queue.arn]
  }
}

resource "aws_sqs_queue_policy" "sqs_access_policy" {
  queue_url = aws_sqs_queue.node_interruption_queue.id
  policy    = data.aws_iam_policy_document.sqs_access_policy_doc.json
}

#EC2 Spot Instance Interruption warning informs Karpenter that a Spot instance being used is about to be reclaimed by AWS.

resource "aws_cloudwatch_event_rule" "spot_interruption_warning_handler" {
  name        = "e6data-${local.short_workspace_name}-capture-spot-interruption-warning"
  description = "Capture spot interruption warning for karpenter"

  event_pattern = jsonencode({
    "source": ["aws.ec2"],
    "detail-type": ["EC2 Spot Instance Interruption Warning"]
  })
}

##The ScheduledChangeRule is captured by Karpenter, which sends AWS health events to KarpenterInterruptionQueue. 
##This allows Karpenter to manage nodes proactively, ensuring graceful handling of interruptions by draining affected nodes and rescheduling pods for high availability and minimal disruptions.
resource "aws_cloudwatch_event_rule" "aws_health_event_handler" {
  name        = "e6data-${local.short_workspace_name}-capture-aws-health-event"
  description = "Capture AWS Health events for karpenter"

  event_pattern = jsonencode({
    "source": ["aws.health"],
    "detail-type": ["AWS Health Event"]
  })
}

#An EC2 Instance Rebalance Recommendation signal informs Karpenter that a Spot instance is at a heightened risk of being interrupted, allowing new instances to be acquired or workloads to be rebalanced.
resource "aws_cloudwatch_event_rule" "ec2_rebalance_recommendation_handler" {
  name        = "e6data-${local.short_workspace_name}-capture-ec2-rebalance-recommendation"
  description = "Capture EC2 instance rebalance recommendation for karpenter"

  event_pattern = jsonencode({
    "source": ["aws.ec2"],
    "detail-type": ["EC2 Instance Rebalance Recommendation"]
  })
}

#The InstanceStateChangeRule is observed by Karpenter, which monitors EC2 instance state changes (e.g., pending, running, stopping, stopped, shutting-down, terminated) and sends these events to the KarpenterInterruptionQueue. 
#This enables Karpenter to track instance states and perform necessary actions, such as draining and rescheduling pods.
resource "aws_cloudwatch_event_rule" "ec2_state_change_notification_handler" {
  name        = "e6data-${local.short_workspace_name}-capture-ec2-state-change-notification"
  description = "Capture EC2 instance state change notification for karpenter"

  event_pattern = jsonencode({
    "source": ["aws.ec2"],
    "detail-type": ["EC2 Instance State-change Notification"]
  })
}

resource "aws_cloudwatch_event_target" "spot_interruption_sqs_target" {
  rule      = aws_cloudwatch_event_rule.spot_interruption_warning_handler.name
  target_id = "SendToSQS"
  arn       = aws_sqs_queue.node_interruption_queue.arn
}

resource "aws_cloudwatch_event_target" "aws_health_event_sqs_target" {
  rule      = aws_cloudwatch_event_rule.aws_health_event_handler.name
  target_id = "SendToSQS"
  arn       = aws_sqs_queue.node_interruption_queue.arn
}

resource "aws_cloudwatch_event_target" "ec2_rebalance_recommendation_sqs_target" {
  rule      = aws_cloudwatch_event_rule.ec2_rebalance_recommendation_handler.name
  target_id = "SendToSQS"
  arn       = aws_sqs_queue.node_interruption_queue.arn
}

resource "aws_cloudwatch_event_target" "ec2_state_change_notification_sqs_target" {
  rule      = aws_cloudwatch_event_rule.ec2_state_change_notification_handler.name
  target_id = "SendToSQS"
  arn       = aws_sqs_queue.node_interruption_queue.arn
}