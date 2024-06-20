resource "aws_route_table_association" "aws_route_table_association_a" {
  subnet_id = aws_subnet.aws_subnet_a.id
  route_table_id = aws_route_table.aws_route_table.id
}

resource "aws_route_table_association" "aws_route_table_association_b" {
  subnet_id = aws_subnet.aws_subnet_b.id
  route_table_id = aws_route_table.aws_route_table.id
}