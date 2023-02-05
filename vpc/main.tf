locals {
  prevent_destruction = true
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.tags,
    var.default_tags,
    map(
      "Name", "vpc-${var.service}-${var.accessibility}-${var.tags["environment"]}",
      "service", "${var.service}"
  ))

  lifecycle {
    prevent_destroy = local.prevent_destruction
  }

}

resource "aws_vpc_dhcp_options" "vpc_dhcp_options" {
  domain_name          = var.domain_name
  domain_name_servers  = ["AmazonProvidedDNS"]
  ntp_servers          = []
  netbios_name_servers = []
  netbios_node_type    = 2
  tags = merge(var.tags,
    var.default_tags,
    map(
      "Name", "vpc-dhcp-options-${var.service}-${var.accessibility}-${var.tags["environment"]}",
      "service", "${var.service}"
  ))

  lifecycle {
    prevent_destroy = local.prevent_destruction
  }

}

resource "aws_vpc_dhcp_options_association" "dhcp_options_association" {
  vpc_id          = aws_vpc.vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.vpc_dhcp_options.id

  lifecycle {
    prevent_destroy = local.prevent_destruction
  }

}

#Internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  count  = length(var.public_subnet) > 0 ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags = merge(var.tags,
    var.default_tags,
    map(
      "Name", "internet-gateway-${var.service}-${var.accessibility}-${var.tags["environment"]}",
      "service", "${var.service}"
  ))

  lifecycle {
    prevent_destroy = local.prevent_destruction
  }

}

#Public subnet
resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet) > 0 ? length(var.public_subnet) : 0
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.public_subnet, count.index)
  availability_zone       = element(var.availability_zone, count.index)
  map_public_ip_on_launch = true
  tags = merge(var.tags,
    var.default_tags,
    map(
      "Name", "public-subnet-${var.service}-${var.accessibility}-${element(var.availability_zone, count.index)}-${var.tags["environment"]}",
      "service", "${var.service}"
  ))

  lifecycle {
    prevent_destroy = local.prevent_destruction
  }

}

#Private subnet
resource "aws_subnet" "private_subnet" {
  count                   = length(var.private_subnet) > 0 ? length(var.private_subnet) : 0
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.private_subnet, count.index)
  availability_zone       = element(var.availability_zone, count.index)
  map_public_ip_on_launch = false
  tags = merge(var.tags,
    var.default_tags,
    map(
      "Name", "private-subnet-${var.service}-${var.accessibility}-${element(var.availability_zone, count.index)}-${var.tags["environment"]}",
      "service", "${var.service}"
  ))

  lifecycle {
    prevent_destroy = local.prevent_destruction
  }
}

#Elastic IP
resource "aws_eip" "elastic_ip" {
  count = length(var.public_subnet) > 0 ? length(var.availability_zone) : 0
  vpc   = true
  tags = merge(var.tags,
    var.default_tags,
    map(
      "Name", "elastic-ip-${var.service}-${var.accessibility}-${element(var.availability_zone, count.index)}-${var.tags["environment"]}",
      "service", "${var.service}"
  ))

  lifecycle {
    prevent_destroy = local.prevent_destruction
  }

}

#NAT gateway
resource "aws_nat_gateway" "nat_gateway" {
  count         = length(var.public_subnet) > 0 ? length(var.availability_zone) : 0
  allocation_id = element(aws_eip.elastic_ip.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)
  tags = merge(var.tags,
    var.default_tags,
    map(
      "Name", "nat-gateway-${var.service}-${var.accessibility}-${element(var.availability_zone, count.index)}-${var.tags["environment"]}",
      "service", "${var.service}"
  ))

  lifecycle {
    prevent_destroy = local.prevent_destruction
  }

}

#Public route table & association
resource "aws_route_table" "public_route_table" {
  count  = length(var.public_subnet) > 0 ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_internet_gateway.internet_gateway.*.id, count.index)
  }
  tags = merge(var.tags,
    var.default_tags,
    map(
      "Name", "public-route-table-${var.service}-${var.accessibility}-${var.tags["environment"]}",
      "service", "${var.service}"
  ))

  lifecycle {
    prevent_destroy = local.prevent_destruction
  }

}

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.public_subnet) > 0 ? length(var.public_subnet) : 0
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.public_route_table.*.id, count.index)

  lifecycle {
    prevent_destroy = local.prevent_destruction
  }

}

#Private route table & association
resource "aws_route_table" "private_route_table" {
  count  = length(var.public_subnet) > 0 ? length(var.availability_zone) : 0
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_nat_gateway.nat_gateway.*.id, count.index)
  }
  tags = merge(var.tags,
    var.default_tags,
    map(
      "Name", "private-route-table-${var.service}-${var.accessibility}-${element(var.availability_zone, count.index)}-${var.tags["environment"]}",
      "service", "${var.service}"
  ))

  lifecycle {
    prevent_destroy = local.prevent_destruction
  }

}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.public_subnet) > 0 ? length(var.private_subnet) : 0
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.private_route_table.*.id, count.index)

  lifecycle {
    prevent_destroy = local.prevent_destruction
  }

}