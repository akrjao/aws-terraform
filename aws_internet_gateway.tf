resource "aws_internet_gateway" "aws_internet_gateway" {
  vpc_id = aws_vpc.aws_vpc.id
}