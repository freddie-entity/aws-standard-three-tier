resource "aws_db_subnet_group" "main" {
  name       = "${var.tier}"
  subnet_ids = var.db_subnets

  tags = {
    Name = var.tier
  }
}

resource "aws_db_parameter_group" "main" {
  name   = "${var.tier}"
  family = "postgres13"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "main" {
  identifier = var.tier
  allocated_storage    = var.allocated_storage
  db_name              = var.db_name
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = var.username
  password             = var.password
  parameter_group_name = aws_db_parameter_group.main.name
  skip_final_snapshot  = true
  publicly_accessible    = true
  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name = aws_db_subnet_group.main.name
}
