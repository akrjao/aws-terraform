resource "aws_subnet" "aws_subnet_a" {
  vpc_id = aws_vpc.aws_vpc.id
  cidr_block = "10.0.0.0/28"
  availability_zone = "${var.aws_region.availability_zone_a}"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "aws_subnet_b" {
  vpc_id = aws_vpc.aws_vpc.id
  cidr_block = "10.0.0.16/28"
  availability_zone = "${var.aws_region.availability_zone_b}"
  map_public_ip_on_launch = true
}