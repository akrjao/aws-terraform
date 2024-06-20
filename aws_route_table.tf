resource "aws_route_table" "aws_route_table" {
  vpc_id = aws_vpc.aws_vpc.id
}