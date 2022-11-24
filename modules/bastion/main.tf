data "aws_ami" "bastion_ami" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name = "name"
    values = [ "amzn2-ami-hvm-*-gp2" ]
  }
  filter {
    name = "root-device-type"
    values = [ "ebs" ]
  }
  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }
  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }
}

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.bastion_ami.id
  instance_type = var.ec2_instance_type
  security_groups = var.security_group_ids
  subnet_id = var.application_subnets[0]
  key_name = var.ec2_key_pair_name

  tags = {
    Name = "Bastion"
  }
}

resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  vpc      = true
}