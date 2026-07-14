resource "aws_cloudwatch_metric_alarm" "billing_alarm" {
  alarm_name          = var.alarm_name
  alarm_description   = "Alarm when AWS estimated charges exceed $350 USD"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = var.metrics_name
  namespace           = "AWS/Billing"
  period              = 21600
  statistic           = "Maximum"
  threshold           = 350

  dimensions = {
    Currency = "USD"
  }

  treat_missing_data = "notBreaching"

  alarm_actions = [
    aws_sns_topic.billing_alerts.arn
  ]

}