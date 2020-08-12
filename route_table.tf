resource "aws_internet_gateway" "hirokihello" {
  vpc_id = "${aws_vpc.hirokihello.id}"

  tags = {
    Name = "hirokihello-${var.stage}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.hirokihello.id}"

  tags = {
    Name = "hirokihello-${var.stage}-private"
  }
}

resource "aws_route_table_association" "private" {
  count = "${length(local.azs)}"
  route_table_id = "${aws_route_table.private.id}"
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
}

# 必要そうになったら作成する
resource "aws_route" "private-default" {
  count = 1
  route_table_id         = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${element(aws_nat_gateway.hirokihello.*.id, count.index)}"
  depends_on = ["aws_route_table.private"]
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.hirokihello.id}"

  tags = {
    Name = "hirokihello-${var.stage}-public"
  }
}

resource "aws_route_table_association" "public" {
  count = "${length(local.azs)}"
  route_table_id = "${aws_route_table.public.id}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
}

resource "aws_route" "public-default" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.hirokihello.id}"
  depends_on = ["aws_route_table.public"]
}
