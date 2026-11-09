resource "aws_route_table" "route_table" {
    vpc_id = aws_vpc.main_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }
}

resource "aws_route_table_association" "public_subnets" {
    count = length(var.public_subnets)
    route_table_id = aws_route_table.route_table.id
    subnet_id = aws_subnet.public_subnets[count.index].id

}

resource "aws_route_table" "private_db_route_table" {
    vpc_id = aws_vpc.main_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_gateway.id
    }
}

resource "aws_route_table_association" "private_servers_subnets" {
  count = length(var.private_servers_subnets)
  route_table_id = aws_route_table.private_db_route_table.id
  subnet_id = aws_subnet.private_servers_subnets[count.index].id
}

resource "aws_route_table_association" "private_db_subnets" {   
  count = length(var.private_db_subnets)
  route_table_id = aws_route_table.private_db_route_table.id
  subnet_id = aws_subnet.private_db_subnets[count.index].id
}