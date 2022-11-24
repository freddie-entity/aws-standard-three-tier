resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Internet reaching access for EC2 instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    protocol    = "TCP"
    to_port     = 22
    cidr_blocks = [var.bastion_ssh_ip]   # put own ip here when demonstrating
  }
  
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "webtier" {
  name        = "webtier"
  description = "Internet reaching access for EC2 instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    protocol    = "TCP"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 0
    protocol        = "-1"
    to_port         = 0
    security_groups = [aws_security_group.bastion.id]
  }


  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "apptier" {
  name        = "apptier"
  description = "Only allow public EC2 instances to access these instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 0
    protocol        = "-1"
    to_port         = 0
    security_groups = [aws_security_group.bastion.id, aws_security_group.webtier.id]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "databasetier" {
  name        = "databasetier"
  description = "Only allow public EC2 instances to access these instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 0
    protocol        = "-1"
    to_port         = 0
    security_groups = [aws_security_group.bastion.id, aws_security_group.apptier.id]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
