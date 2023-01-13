resource "aws_cloudwatch_log_group" "log_group" {
  name              = var.log_group_name
  retention_in_days = var.retention_days

  tags = merge(tomap({
    "environment" = "${var.tags["environment"]}" }),
    var.default_tags,
    var.tags
  )
}

