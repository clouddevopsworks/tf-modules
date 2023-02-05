output "dns_hosted_zone_id_public_zone" {
  value = aws_route53_zone.dns_hosted_zone_public.*.zone_id
}

output "name_servers_public_zone" {
  value = aws_route53_zone.dns_hosted_zone_public.*.name_servers
}

output "dns_hosted_zone_id_private_zone" {
  value = aws_route53_zone.dns_hosted_zone_private.*.zone_id
}

output "name_servers_private_zone" {
  value = aws_route53_zone.dns_hosted_zone_private.*.name_servers
}