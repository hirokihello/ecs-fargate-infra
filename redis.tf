# resource "aws_elasticache_parameter_group" "redis" {
#   name = "redis-${var.stage}"
#   family = "redis2.8"
# }

# resource "aws_elasticache_subnet_group" "redis" {
#   name        = "redis-${var.stage}"
#   description = "redis-${var.stage}"
#   subnet_ids  = [
#                   for subnet in aws_subnet.private:
#                   subnet.id
#                 ]
# }

# resource "aws_elasticache_cluster" "redis" {
#   cluster_id           = "redis-${var.stage}"
#   engine               = "redis"
#   engine_version       = "2.8.24"
#   node_type            = "cache.t2.micro"
#   num_cache_nodes      = 1
#   parameter_group_name = "${aws_elasticache_parameter_group.redis.name}"
#   port                 = 6379
#   subnet_group_name    = "${aws_elasticache_subnet_group.redis.name}"
#   security_group_ids   = ["${aws_security_group.redis.id}"]
# }
