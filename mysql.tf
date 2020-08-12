resource "aws_db_subnet_group" "aurora-dbsubnet" {
  name        = "aurora-${var.stage}-dbsubnet"
  description = "aurora-${var.stage}-dbsubnet"
  subnet_ids  = [
                  for subnet in aws_subnet.private:
                  subnet.id
                ]
}

resource "aws_rds_cluster" "aurora-mysql" {
  cluster_identifier              = "aurora-${var.stage}-mysql-cluster"
  engine                          = "aurora-mysql"
  engine_version                  = "5.7.12"
  availability_zones              = [
                                      for name in data.aws_availability_zones.available.names:
                                      name
                                    ]
  database_name                   = "aurora_${var.stage}"
  master_username                 = "test"
  master_password                 = "${var.db_password}"
  final_snapshot_identifier       = "aurora-${var.stage}-mysql-final"
  backup_retention_period         = 7
  preferred_backup_window         = "19:30-20:30"
  preferred_maintenance_window    = "sat:18:00-sat:19:00"
  vpc_security_group_ids          = ["${aws_security_group.aurora-mysql.id}"]
  db_subnet_group_name            = "${aws_db_subnet_group.aurora-dbsubnet.name}"
  db_cluster_parameter_group_name = "${aws_rds_cluster_parameter_group.aurora-cluster.name}"

  lifecycle {
    ignore_changes  = [
      "final_snapshot_identifier",
      "snapshot_identifier",
    ]
  }
}
resource "aws_rds_cluster_instance" "aurora-staging-aurora-mysql-01" {
  count                   = 1
  identifier              = "${var.stage}-aurora-mysql-01"
  cluster_identifier      = "${aws_rds_cluster.aurora-mysql.cluster_identifier}"
  instance_class          = "db.t3.small"
  publicly_accessible     = false
  db_subnet_group_name    = "${aws_db_subnet_group.aurora-dbsubnet.name}"
  db_parameter_group_name = "${aws_db_parameter_group.aurora.name}"
  apply_immediately       = false
  engine                  = "aurora-mysql"
  engine_version          = "5.7.12"
  tags = {
    CostGroup = "aurora-${var.stage}"
    workload-type = "aurora-${var.stage}"
  }
}

resource "aws_rds_cluster_instance" "aurora-staging-aurora-mysql-02" {
  count                   = 1
  identifier              = "${var.stage}-aurora-mysql-02"
  cluster_identifier      = "${aws_rds_cluster.aurora-mysql.cluster_identifier}"
  instance_class          = "db.t3.small"
  publicly_accessible     = false
  db_subnet_group_name    = "${aws_db_subnet_group.aurora-dbsubnet.name}"
  db_parameter_group_name = "${aws_db_parameter_group.aurora.name}"
  apply_immediately       = false
  engine                  = "aurora-mysql"
  engine_version          = "5.7.12"
  tags = {
    CostGroup = "aurora-${var.stage}"
    workload-type = "aurora-${var.stage}"
  }
}

resource "aws_rds_cluster_parameter_group" "aurora-cluster" {
  name = "aurora-${var.stage}-aurora-cluster"
  family = "aurora-mysql5.7"
  description = "aurora-${var.stage}-aurora-cluster"

  parameter {
    name         = "binlog_format"
    value        = "ROW"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "character_set_client"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_connection"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_database"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_filesystem"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_results"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_server"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "collation_connection"
    value        = "utf8mb4_general_ci"
    apply_method = "immediate"
  }

  parameter {
    name         = "collation_server"
    value        = "utf8mb4_general_ci"
    apply_method = "immediate"
  }

  parameter {
    name         = "innodb_file_per_table"
    value        = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "skip-character-set-client-handshake"
    value        = "0"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "time_zone"
    value        = "Asia/Tokyo"
    apply_method = "immediate"
  }
}

resource "aws_db_parameter_group" "aurora" {
  name        = "aurora-${var.stage}-aurora"
  family      = "aurora-mysql5.7"
  description = "aurora-${var.stage}-aurora"

  parameter {
    name         = "innodb_lock_wait_timeout"
    value        = "5"
    apply_method = "immediate"
  }

  parameter {
    name         = "long_query_time"
    value        = "0.5"
    apply_method = "immediate"
  }

  parameter {
    name         = "log_bin_trust_function_creators"
    value        = "1"
    apply_method = "immediate"
  }

  parameter {
    name         = "query_cache_size"
    value        = "0"
    apply_method = "immediate"
  }

  parameter {
    name         = "query_cache_type"
    value        = "0"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "slow_query_log"
    value        = "1"
    apply_method = "immediate"
  }
}
