// WireGuard VPC
resource "aws_vpc" "wireguard-vpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"

    enable_dns_hostnames = true

    tags = {
        Name = "wireguard-vpc"
    }
}

// WireGuard VPC Subnet 1
resource "aws_subnet" "wireguard-vpc-subnet-1" {
    vpc_id = aws_vpc.wireguard-vpc.id
    cidr_block = "10.0.1.0/24"

    map_public_ip_on_launch = true
    availability_zone = "ap-southeast-2a"

    tags = {
        Name = "wireguard-vpc-subnet-1"
    }
}

// WireGuard VPC Subnet 2
resource "aws_subnet" "wireguard-vpc-subnet-2" {
    vpc_id = aws_vpc.wireguard-vpc.id
    cidr_block = "10.0.2.0/24"

    map_public_ip_on_launch = true
    availability_zone = "ap-southeast-2b"

    tags = {
        Name = "wireguard-vpc-subnet-2"
    }
}

// WireGuard VPC Route Table
resource "aws_route_table" "wireguard-vpc-route-table" {
  vpc_id = aws_vpc.wireguard-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wireguard-vpc-internet-gateway.id
  }

  tags = {
    Name = "wireguard-vpc-route-table"
  }
}

// WireGuard VPC Route Table Association 1
resource "aws_route_table_association" "wireguard-vpc-route-table-assoc-1" {
    subnet_id = aws_subnet.wireguard-vpc-subnet-1.id
    route_table_id = aws_route_table.wireguard-vpc-route-table.id
}

// WireGuard VPC Route Table Association 2
resource "aws_route_table_association" "wireguard-vpc-route-table-assoc-2" {
    subnet_id = aws_subnet.wireguard-vpc-subnet-2.id
    route_table_id = aws_route_table.wireguard-vpc-route-table.id
}

// WireGuard Internet Gateway
resource "aws_internet_gateway" "wireguard-vpc-internet-gateway" {
    vpc_id = aws_vpc.wireguard-vpc.id

    tags = {
      Name = "wireguard-vpc-internet-gateway"
    }
}

// WireGuard Security Group
resource "aws_security_group" "wireguard-nsg" {
    name = "wireguard-nsg"

    vpc_id = aws_vpc.wireguard-vpc.id

    tags = {
        Name = "wireguard-nsg"
    }
}

// WireGuard Security Group Rules

// SSH
resource "aws_vpc_security_group_ingress_rule" "wireguard-nsg-rule-ssh" {
    security_group_id = aws_security_group.wireguard-nsg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
}

// HTTP
resource "aws_vpc_security_group_ingress_rule" "wireguard-nsg-rule-http" {
    security_group_id = aws_security_group.wireguard-nsg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
}

// WireGuard
resource "aws_vpc_security_group_ingress_rule" "wireguard-nsg-rule-wireguard" {
    security_group_id = aws_security_group.wireguard-nsg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 51820
    to_port = 51820
    ip_protocol = "udp"
}