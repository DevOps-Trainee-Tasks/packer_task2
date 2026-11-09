resource "aws_eip" "eip" {
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.public_subnets[var.nat_gateway_public_subnet_index].id 
  depends_on = [aws_internet_gateway.internet_gateway]
}