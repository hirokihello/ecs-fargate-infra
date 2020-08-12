resource "aws_security_group" "aurora-mysql" {
  name        = "hirokihello-${var.stage}-aurora-mysql"
  description = "hirokihello-${var.stage}-aurora-mysql"
  vpc_id      = aws_vpc.hirokihello.id

  tags = {
    Name = "hirokihello-${var.stage}-aurora-mysql"
  }
}

resource "aws_security_group_rule" "aurora-mysql-ingress" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.hirokihello.cidr_block,]
  security_group_id = aws_security_group.aurora-mysql.id
}

resource "aws_security_group_rule" "aurora-mysql-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aurora-mysql.id
}

# resource "aws_security_group" "redis" {
#   name        = "hirokihello-${var.stage}-redis"
#   description = "hirokihello-${var.stage}-redis"
#   vpc_id      = aws_vpc.hirokihello.id

#   tags = {
#     Name = "hirokihello-${var.stage}-redis"
#   }
# }

# resource "aws_security_group_rule" "redis-ingress" {
#   type              = "ingress"
#   from_port         = 6379
#   to_port           = 6379
#   protocol          = "tcp"
#   cidr_blocks       = [aws_vpc.hirokihello.cidr_block,]
#   security_group_id = aws_security_group.redis.id
# }

# resource "aws_security_group_rule" "redis-egress" {
#   type              = "egress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.redis.id
# }

resource "aws_security_group" "fargate" {
  name        = "hirokihello-${var.stage}-instance"
  description = "hirokihello-${var.stage}-instance"
  vpc_id      = aws_vpc.hirokihello.id

  tags = {
    Name = "hirokihello-${var.stage}-instance"
  }
}

resource "aws_security_group_rule" "fargate-ingress-internal" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [aws_vpc.hirokihello.cidr_block]
  security_group_id = aws_security_group.fargate.id
}

resource "aws_security_group_rule" "fargate-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.fargate.id
}

resource "aws_security_group" "alb" {
  name        = "hirokihello-${var.stage}-alb"
  description = "hirokihello-${var.stage}-alb"
  vpc_id      = aws_vpc.hirokihello.id

  tags = {
    Name = "hirokihello-${var.stage}-alb"
  }
}

resource "aws_security_group_rule" "alb-ingress-http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.cidr-all
  security_group_id = "${aws_security_group.alb.id}"
}

resource "aws_security_group_rule" "alb-ingress-https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.cidr-all
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "alb-ingress-internal" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [aws_vpc.hirokihello.cidr_block]
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "alb-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}
