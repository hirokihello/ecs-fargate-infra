resource "aws_vpc" "hirokihello" {
  cidr_block           = "10.12.16.0/20"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "hirokihello-${var.stage}-vpc"
  }
}

resource "aws_subnet" "private" {
  count             = length(local.azs)
  vpc_id            = aws_vpc.hirokihello.id
  cidr_block        = cidrsubnet(aws_vpc.hirokihello.cidr_block, 3, count.index)
  availability_zone = element(local.azs, count.index)

  tags = {
    Name = "hirokihello-${var.stage}-private-${element(local.azs, count.index)}"
  }
}

resource "aws_subnet" "public" {
  count             = length(local.azs)
  vpc_id            = aws_vpc.hirokihello.id
  cidr_block        = cidrsubnet(aws_vpc.hirokihello.cidr_block, 3, count.index + 3)
  availability_zone = element(local.azs, count.index)


  map_public_ip_on_launch = true
  tags = {
    Name = "hirokihello-${var.stage}-public-${element(local.azs, count.index)}"
  }
}

