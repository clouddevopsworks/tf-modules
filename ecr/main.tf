resource "aws_ecr_repository" "ecr_repository" {
  name                 = "ecr-${var.application}-${var.tags["environment"]}"
  image_tag_mutability = var.tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan
  }

  tags = merge(tomap({
    Name = "ecr-${var.application}-${var.tags["environment"]}",
    "environment" = "${var.tags["environment"]}" }),
    var.default_tags,
    var.tags
  )

}

