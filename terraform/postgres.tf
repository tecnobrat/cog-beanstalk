resource "aws_db_instance" "cog_postgres" {
  engine     = "postgres"
  identifier = "postgres-${var.app_name}" # This is the instance name.
  name       = "cog"                      # This is the DATABASE name, not the instance name.

  username = "${var.postgres_username}"
  password = "${var.postgres_password}"

  allocated_storage         = "${var.postgres_storage}"
  backup_retention_period   = "${var.postgres_backup_retention_period}"
  backup_window             = "${var.postgres_backup_window}"
  db_subnet_group_name      = "${aws_db_subnet_group.cog_postgres.name}"
  final_snapshot_identifier = "postgres-${var.app_name}-final-snapshot"
  instance_class            = "${var.postgres_instance_type}"
  maintenance_window        = "${var.postgres_maintenance_window}"
  multi_az                  = false
  publicly_accessible       = false
  storage_type              = "gp2"
  vpc_security_group_ids    = ["${aws_security_group.cog_postgres.id}"]

  # This apply_immediately is temporary until live launch
  apply_immediately = true

  lifecycle {
    prevent_destroy = true
  }

  tags {
    Name = "${var.app_name}-postgres"
  }
}

resource "aws_db_subnet_group" "cog_postgres" {
  name = "${var.app_name}-postgres"
  description = "Postgres ${var.app_name}-postgres Subnet"
  subnet_ids = [ "${split(",", var.vpc_subnets)}" ]

  tags {
    Name = "${var.app_name}-postgres"
  }
}

resource "aws_security_group" "cog_postgres" {
  name        = "${var.app_name}-postgres"
  description = "Postgres ${var.app_name}-postgres Security Group"
  vpc_id      = "${var.vpc_id}"

  ingress {
    protocol        = "tcp"
    security_groups = ["${aws_security_group.cog.id}"]

    from_port = 5432
    to_port   = 5432
  }

  tags {
    Name = "${var.app_name}-postgres"
  }
}
