resource "aws_vpc" "main_vpc" {
    cidr_block = var.cidr
    tags = {
        Name = "${var.name_prefix}-vpc"
    }

}

resource "aws_subnet" "public_subnets" {
    vpc_id = aws_vpc.main_vpc.id
    count = length(var.public_subnets)
    cidr_block = var.public_subnets[count.index]
    availability_zone = var.available_zones_list[count.index % length(var.available_zones_list)]
    map_public_ip_on_launch = true
    tags = {
        Name = "${var.name_prefix}-public-${count.index + 1}"
    }

}

resource "aws_subnet" "private_servers_subnets" {
    vpc_id = aws_vpc.main_vpc.id
    count = length(var.private_servers_subnets)
    cidr_block = var.private_servers_subnets[count.index]
    availability_zone = var.available_zones_list[count.index % length(var.available_zones_list)]
    tags = {
        Name = "${var.name_prefix}-private-servers-${count.index + 1}"
    }
}

resource "aws_subnet" "private_db_subnets" {
  vpc_id = aws_vpc.main_vpc.id
  count = length(var.private_db_subnets)
  cidr_block = var.private_db_subnets[count.index]
  availability_zone = var.available_zones_list[count.index % length(var.available_zones_list)]
  tags = {
      Name = "${var.name_prefix}-private-db-${count.index + 1}"
  }
}