#==========VPC=and=IGW==========#
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "Main_VPC"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Main_IGW"
  }
}

#==========Public=subnets=and=Routing==========#
resource "aws_subnet" "public" {
  count                   = length(var.public_cidr_blocks)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_cidr_blocks, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-subnet-${count.index}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "Public-route"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public[*])
  route_table_id = aws_route_table.public.id
  subnet_id      = element(aws_subnet.public[*].id, count.index)
}

#==========NATGTW=and=EIP==========#
resource "aws_eip" "nat" {
  count = length(var.private_cidr_blocks)
  vpc   = true

  tags = {
    Name = "Nat-EIP-${count.index}"
  }
}

resource "aws_nat_gateway" "this" {
  count         = length(var.private_cidr_blocks)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = element(aws_subnet.public[*].id, count.index)

  tags = {
    Name = "NAT-GW-${count.index}"
  }
}

#==========Private=subnets=and=Routing==========#
resource "aws_subnet" "private" {
  count             = length(var.private_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_cidr_blocks, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "Private-subnet-${count.index}"
  }
}

resource "aws_route_table" "private" {
  count  = length(var.private_cidr_blocks)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.this[count.index].id
  }

  tags = {
    Name = "Private-route-${count.index}"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private[*])
  route_table_id = aws_route_table.private[count.index].id
  subnet_id      = element(aws_subnet.private[*].id, count.index)
}
