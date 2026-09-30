resource "aws_subnet" "this" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = var.is_public

  tags = merge(var.tags, {
    Name = var.subnet_name
    Type = var.is_public ? "public" : "private"
  })
}
# Associate route table only if subnet is public
resource "aws_route_table_association" "public" {
  count = var.is_public ? 1 : 0

  subnet_id      = aws_subnet.this.id
  route_table_id = var.public_route_table_id
}
