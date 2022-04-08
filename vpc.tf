resource "aws_vpc" "main" {
  cidr_block = var.VPC_CIDR

  tags = {
    Name = "${var.AWS_ENV}-VPC"
  }
}

resource "aws_subnet" "public_SN1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.PUBLIC_SN1_CIDR
  map_public_ip_on_launch = true
  availability_zone       = "${var.AWS_REGION}a"

  tags = {
    Name = "${var.AWS_ENV}-public-SN1"
  }
}

resource "aws_subnet" "public_SN2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.PUBLIC_SN2_CIDR
  map_public_ip_on_launch = true
  availability_zone       = "${var.AWS_REGION}b"

  tags = {
    Name = "${var.AWS_ENV}-public-SN2"
  }
}

resource "aws_subnet" "public_SN3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.PUBLIC_SN3_CIDR
  map_public_ip_on_launch = true
  availability_zone       = "${var.AWS_REGION}c"

  tags = {
    Name = "${var.AWS_ENV}-public-SN3"
  }
}


resource "aws_subnet" "private_SN1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.PRIVATE_SN1_CIDR
  map_public_ip_on_launch = false
  availability_zone       = "${var.AWS_REGION}a"

  tags = {
    Name = "${var.AWS_ENV}-private-SN1"
  }
}

resource "aws_subnet" "private_SN2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.PRIVATE_SN2_CIDR
  map_public_ip_on_launch = false
  availability_zone       = "${var.AWS_REGION}b"

  tags = {
    Name = "${var.AWS_ENV}-private-SN2"
  }
}

resource "aws_subnet" "private_SN3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.PRIVATE_SN3_CIDR
  map_public_ip_on_launch = false
  availability_zone       = "${var.AWS_REGION}c"

  tags = {
    Name = "${var.AWS_ENV}-private-SN3"
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.AWS_ENV}-IGW"
  }
}

resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
  tags = {
    Name = "${var.AWS_ENV}-public-SN-RTB"
  }
}

resource "aws_route_table_association" "rtbassoc1" {
  subnet_id      = aws_subnet.public_SN1.id
  route_table_id = aws_route_table.rtb.id
}

resource "aws_route_table_association" "rtbassoc2" {
  subnet_id      = aws_subnet.public_SN2.id
  route_table_id = aws_route_table.rtb.id
}

resource "aws_route_table_association" "rtbassoc3" {
  subnet_id      = aws_subnet.public_SN3.id
  route_table_id = aws_route_table.rtb.id
}


resource "aws_eip" "eip1" {
  network_border_group = var.AWS_REGION
}

resource "aws_eip" "eip2" {
  network_border_group = var.AWS_REGION
}

resource "aws_eip" "eip3" {
  network_border_group = var.AWS_REGION
}


resource "aws_nat_gateway" "nat_gw1" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.public_SN1.id

  tags = {
    Name = "${var.AWS_ENV}-public-SN1-NAT-GW"
  }

  depends_on = [aws_internet_gateway.main_igw]
}

resource "aws_nat_gateway" "nat_gw2" {
  allocation_id = aws_eip.eip2.id
  subnet_id     = aws_subnet.public_SN2.id

  tags = {
    Name = "${var.AWS_ENV}-public-SN2-NAT-GW"
  }

  depends_on = [aws_internet_gateway.main_igw]
}

resource "aws_nat_gateway" "nat_gw3" {
  allocation_id = aws_eip.eip3.id
  subnet_id     = aws_subnet.public_SN3.id

  tags = {
    Name = "${var.AWS_ENV}-public-SN3-NAT-GW"
  }

  depends_on = [aws_internet_gateway.main_igw]
}

resource "aws_route_table" "nat_gw1_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw1.id
  }
  tags = {
    Name = "${var.AWS_ENV}-NAT-GW1-RT"
  }
}

resource "aws_route_table" "nat_gw2_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw2.id
  }
  tags = {
    Name = "${var.AWS_ENV}-NAT-GW2-RT"
  }
}

resource "aws_route_table" "nat_gw3_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw3.id
  }
  tags = {
    Name = "${var.AWS_ENV}-NAT-GW3s-RT"
  }
}

resource "aws_route_table_association" "rtbassoc4" {
  subnet_id      = aws_subnet.private_SN1.id
  route_table_id = aws_route_table.nat_gw1_rt.id
}

resource "aws_route_table_association" "rtbassoc5" {
  subnet_id      = aws_subnet.private_SN2.id
  route_table_id = aws_route_table.nat_gw2_rt.id
}

resource "aws_route_table_association" "rtbassoc6" {
  subnet_id      = aws_subnet.private_SN3.id
  route_table_id = aws_route_table.nat_gw3_rt.id
}