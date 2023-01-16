resource "aws_route53_record" "route53_record" {
  zone_id = var.zone_id
  name    = var.fqdn
  type    = var.record_type
  ttl     = var.ttl
  records = var.record
}

