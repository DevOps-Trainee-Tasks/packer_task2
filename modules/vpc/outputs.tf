output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "private_servers_subnet_ids" {
  value = aws_subnet.private_servers_subnets[*].id
}

output "private_db_subnet_ids" {
  value = aws_subnet.private_db_subnets[*].id
}