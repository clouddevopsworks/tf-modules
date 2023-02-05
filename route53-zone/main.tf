resource "aws_route53_zone" "dns_hosted_zone_public" {
  count = var.private_zone == false ? 1 : 0
  name  = var.domain_name

  tags = merge(var.tags,
    var.default_tags,
    map(
      "Name", "hosted-zone-${var.service}-${var.accessibility}-${var.tags["environment"]}",
      "domain_name", "${var.domain_name}",
      "service", "${var.service}"
  ))
}

resource "aws_route53_zone" "dns_hosted_zone_private" {
  count = var.private_zone == true ? 1 : 0
  name  = var.domain_name

  vpc {
    vpc_id = var.vpc_id
  }

  tags = merge(var.tags,
    var.default_tags,
    map(
      "Name", "hosted-zone-${var.service}-${var.accessibility}-${var.tags["environment"]}",
      "domain_name", "${var.domain_name}",
      "service", "${var.service}"
  ))
}