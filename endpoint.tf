resource "aws_vpc_endpoint" "ecr" {
  vpc_id            = aws_vpc.hirokihello.id
  service_name      = "com.amazonaws.ap-northeast-1.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [
                        for subnet in aws_subnet.private:
                        subnet.id
                      ]
  security_group_ids = [
    aws_security_group.fargate.id,
  ]

  private_dns_enabled = true
}
resource "aws_vpc_endpoint" "logs" {
  vpc_id            = aws_vpc.hirokihello.id
  service_name      = "com.amazonaws.ap-northeast-1.logs"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [
                        for subnet in aws_subnet.private:
                        subnet.id
                      ]
  security_group_ids = [
    aws_security_group.fargate.id,
  ]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.hirokihello.id
  service_name = "com.amazonaws.ap-northeast-1.s3"
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = aws_route_table.private.id
}
