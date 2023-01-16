output "record_name" {
  value = aws_route53_record.route53_record.name
}

output "fqdn" {
  value = aws_route53_record.route53_record.fqdn
}