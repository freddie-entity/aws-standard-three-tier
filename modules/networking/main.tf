### -- VPC --
resource "aws_vpc" "main" {
  cidr_block = var.cidr
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.app_name}-main"
  }
}

### -- Public Subnet --
resource "aws_subnet" "public" {
  count                   = length(var.azs)
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone       = var.azs[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.app_name}-public-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.app_name}-main"
  }
}

resource "aws_route_table" "public_subnet" {
    count = length(var.azs)
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }

    tags = {
        Name = "${var.app_name}-public_subnet"
    }
}

resource "aws_route_table_association" "public_subnet" {
  count = length(var.azs)
  subnet_id = element(aws_subnet.public.*.id, count.index)
  route_table_id = element(aws_route_table.public_subnet.*.id, count.index)
}

### -- Private Subnet --
resource "aws_subnet" "private" {
  count             = length(var.azs)
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 100 + count.index)
  availability_zone = var.azs[count.index]
  vpc_id            = aws_vpc.main.id

  tags = {
    Name = "${var.app_name}-private-${count.index + 1}"
  }
}

resource "aws_eip" "natgw" {
    count = 1
    vpc = true
    depends_on = [aws_vpc.main]

    tags = {
        Name = "${var.app_name}-main"
    }
}

resource "aws_nat_gateway" "primary" {
    count = 1
    subnet_id = element(aws_subnet.public.*.id, count.index)
    allocation_id = element(aws_eip.natgw.*.id, count.index)  
    tags = {
        Name = "${var.app_name}-primary-${count.index + 1}"
    }
}

resource "aws_route_table" "private_subnet" {
    count = length(var.azs)
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = element(aws_nat_gateway.primary.*.id, 0)
        # nat_gateway_id = element(aws_nat_gateway.primary.*.id, count.index)
    }

    tags = {
        Name = "${var.app_name}-private_subnet"
    }
}

resource "aws_route_table_association" "private_subnet" {
  count = length(var.azs)
  subnet_id = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private_subnet.*.id, count.index)
}

