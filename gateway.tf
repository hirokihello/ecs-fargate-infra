resource "aws_nat_gateway" "hirokihello" {
  count = 1
  allocation_id = aws_eip.hirokihello.id
  subnet_id = element(aws_subnet.public.*.id, count.index)
}
