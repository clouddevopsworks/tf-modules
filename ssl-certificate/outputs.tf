output "cartificate_arn" {
  value = aws_acm_certificate.acm_certificate.arn
}

output "cartificate_domain_name" {
  value = aws_acm_certificate.acm_certificate.domain_name
}

output "domain_validation_options" {
  value = aws_acm_certificate.acm_certificate.domain_validation_options
}