resource "aws_route" "aws_route" {
  route_table_id = aws_route_table.aws_route_table.id
  gateway_id = aws_internet_gateway.aws_internet_gateway.id
  destination_cidr_block = "0.0.0.0/0"
}