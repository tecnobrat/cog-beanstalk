# General
variable "app_name" { default = "cog" }
variable "aws_profile" {}
variable "aws_region" {}
variable "aws_account_id" {}

# Instance Settings
variable "ec2_key_name" { }
variable "instance_type" { default = "t2.micro" }

# Postgres Settings
variable "postgres_backup_retention_period" { default = "14" }
variable "postgres_backup_window" { default = "05:00-05:30" }
variable "postgres_instance_type" { default = "db.t2.micro" }
variable "postgres_maintenance_window" { default = "sat:06:00-sat:06:30" }
variable "postgres_password" { default = "somepassword" }
variable "postgres_storage" { default = "20" }
variable "postgres_username" { default = "cog" }

# Cog settings
variable "relay_cog_token" {}
variable "slack_api_token" {}

# VPC settings
variable "vpc_default_security_group" {}
variable "vpc_id" {}
variable "vpc_subnets" {}

# DNS settings
variable "root_domain" { }
variable "domain_count" { default = 0 }
variable "route53_zone_id" { default = "" }
