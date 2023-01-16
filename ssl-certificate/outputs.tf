output "cartificate_arn" {
  value = aws_acm_certificate.acm_certificate.arn
}

output "cartificate_domain_name" {
  value = aws_acm_certificate.acm_certificate.domain_name
}

output "validation_record_name" {
  value = aws_acm_certificate.acm_certificate.resource_record_name
}

output "validation_record_type" {
  value = aws_acm_certificate.acm_certificate.resource_record_type
}

output "validation_record_value" {
  value = aws_acm_certificate.acm_certificate.resource_record_value
}