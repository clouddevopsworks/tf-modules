output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_arn" {
  value = aws_vpc.vpc.arn
}

output "internet_gateway_id" {
  value = aws_internet_gateway.internet_gateway.*.id
}

output "internet_gateway_arn" {
  value = aws_internet_gateway.internet_gateway.*.arn
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gateway.*.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.*.id
}

output "public_subnet_arn" {
  value = aws_subnet.public_subnet.*.arn
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.*.id
}

output "private_subnet_arn" {
  value = aws_subnet.private_subnet.*.arn
}

output "vpc_dhcp_options_id" {
  value = aws_vpc_dhcp_options.vpc_dhcp_options.id
}