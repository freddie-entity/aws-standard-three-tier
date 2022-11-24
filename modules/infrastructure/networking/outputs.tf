output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}

output "public_subnets" {
  value = aws_subnet.public.*.id
}

output "private_subnets" {
  value = aws_subnet.private.*.id
}

output "bastion_security_group_id" {
  value = aws_security_group.bastion.id
}

output "webtier_security_group_id" {
  value = aws_security_group.webtier.id
}

output "apptier_security_group_id" {
  value = aws_security_group.apptier.id
}

output "databasetier_security_group_id" {
  value = aws_security_group.databasetier.id
}