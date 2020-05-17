resource "aws_rds_cluster_parameter_group" "this" {
  name        = "${local.random_string}-${local.user}-pg"
  family      = "aurora5.6"
  description = "RDS default cluster parameter group"

  parameter {
    name  = "character_set_client"
    value = "${var.default_character_set}"
  }

  parameter {
    name  = "character_set_connection"
    value = "${var.default_character_set}"
  }

  parameter {
    name  = "character_set_database"
    value = "${var.default_character_set}"
  }

  parameter {
    name  = "character_set_results"
    value = "${var.default_character_set}"
  }

  parameter {
    name  = "character_set_server"
    value = "${var.default_character_set}"
  }

  parameter {
    name  = "collation_connection"
    value = "${var.default_collation}"
  }

  parameter {
    name  = "collation_server"
    value = "${var.default_collation}"
  }
}

resource "aws_db_parameter_group" "this" {
  name   = "${local.random_string}-${local.user}-db"
  family = "aurora5.6"

  parameter {
    name  = "max_allowed_packet"
    value = "1073741824"
  }

  parameter {
    name  = "log_bin_trust_function_creators"
    value = "1"
  }

  parameter {
    apply_method = "pending-reboot"
    name         = "performance_schema"
    value        = "1"
  }
}

module "aurora" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 1.21"

  name                  = "${local.random_string}-${local.user}-db"
  database_name         = "${var.db_name}"
  username              = "${var.db_user}"
  password              = "${var.db_pass}"
  engine                = "aurora"
  engine_mode           = "serverless"
  replica_scale_enabled = false
  replica_count         = 0

  subnets                         = "${module.vpc.private_subnets}"
  vpc_id                          = "${module.vpc.vpc_id}"
  monitoring_interval             = 60
  instance_type                   = "${var.db_instance_type}"
  allowed_security_groups         = ["${aws_security_group.bastion-sg.id}"]
  allowed_security_groups_count   = 1
  apply_immediately               = true
  skip_final_snapshot             = true
  storage_encrypted               = true
  db_parameter_group_name         = "${aws_db_parameter_group.this.id}"
  db_cluster_parameter_group_name = "${aws_rds_cluster_parameter_group.this.id}"

  scaling_configuration = [
    {
      auto_pause               = true
      max_capacity             = 8
      min_capacity             = 2
      seconds_until_auto_pause = 7200
      timeout_action           = "ForceApplyCapacityChange"
    },
  ]
}
