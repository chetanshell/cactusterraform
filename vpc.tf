# Declare the data source
data "aws_availability_zones" "available" {}


# Define a vpc
resource "aws_vpc" "cactus_vpc" {
  cidr_block = "${var.cactus_cidr}"
  tags = {
    Name = "${var.cactus_vpc}"
  }
}

# IG for the public subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.cactus_vpc.id}"
  tags = {
    Name = "igw"
  }
}

# Public subnet 1
resource "aws_subnet" "public_subnet_01" {
  vpc_id = "${aws_vpc.cactus_vpc.id}"
  cidr_block = "${var.public_cidr_01}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  tags = {
    Name = "public_subnet_01"
  }
}

# Public subnet 2
resource "aws_subnet" "public_subnet_02" {
  vpc_id = "${aws_vpc.cactus_vpc.id}"
  cidr_block = "${var.public_cidr_02}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  tags = {
    Name = "public_subnet_02"
  }
}

# Route table for public subnet 1
resource "aws_route_table" "public_subnet_route_01" {
  vpc_id = "${aws_vpc.cactus_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
  tags = {
    Name = "public_subnet_route_01"
  }
}

# Associate route table to public subnet 1
resource "aws_route_table_association" "public_subnet_route_01_assn" {
  subnet_id = "${aws_subnet.public_subnet_01.id}"
  route_table_id = "${aws_route_table.public_subnet_route_01.id}"
}

# Route table for public subnet 2
resource "aws_route_table" "public_subnet_route_02" {
  vpc_id = "${aws_vpc.cactus_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
  tags = {
    Name = "public_subnet_route_02"
  }
}

# Associate route table to public subnet 2
resource "aws_route_table_association" "public_subnet_route_02_assn" {
  subnet_id = "${aws_subnet.public_subnet_02.id}"
  route_table_id = "${aws_route_table.public_subnet_route_02.id}"
}

# ECS Instance SG
resource "aws_security_group" "cactus_public_sg" {
  name = "cactus_public_sg"
  description = "Cactus Public SG"
  vpc_id = "${aws_vpc.cactus_vpc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = [
      "${var.public_cidr_01}",
      "${var.public_cidr_02}"]
  }

  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = {
    Name = "cactus_public_sg"
  }
}