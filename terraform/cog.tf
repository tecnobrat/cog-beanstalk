resource "aws_elastic_beanstalk_application" "cog" {
  name        = "${var.app_name}-terraform"
  description = "Cog Terraformed"
}

resource "aws_elastic_beanstalk_environment" "cog" {
  name                   = "${var.app_name}-terraform"
  application            = "${aws_elastic_beanstalk_application.cog.name}"
  solution_stack_name    = "64bit Amazon Linux 2016.03 v2.1.3 running Multi-container Docker 1.11.1 (Generic)"
  wait_for_ready_timeout = "20m"

  # Enable Enhanced Health
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = "${aws_iam_role.cog_beanstalk_service.name}"
  }

  # Launch Configuration
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "${var.instance_type}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = "${var.vpc_default_security_group},${aws_security_group.cog.id}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = "${var.ec2_key_name}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "${aws_iam_instance_profile.cog.name}"
  }

  # Environment Variables
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "COG_API_URL_HOST"
    value     = "${var.app_name}.${var.root_domain}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "COG_TRIGGER_URL_HOST"
    value     = "${var.app_name}.${var.root_domain}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "COG_SERVICE_URL_HOST"
    value     = "${var.app_name}.${var.root_domain}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DATABASE_URL"
    value     = "ecto://${aws_db_instance.cog_postgres.username}:${var.postgres_password}@${aws_db_instance.cog_postgres.address}:5432/${aws_db_instance.cog_postgres.name}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RELAY_COG_TOKEN"
    value     = "${var.relay_cog_token}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SLACK_API_TOKEN"
    value     = "${var.slack_api_token}"
  }

  # VPC Settings
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${var.vpc_id}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name = "Subnets"
    value = "${var.vpc_subnets}"
  }

  tags {
    Name = "${var.app_name}"
  }
}

resource "aws_security_group" "cog" {
  description = "Instances for ${var.app_name}"
  name        = "${var.app_name}"
  vpc_id      = "${var.vpc_id}"

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    from_port = 4000
    to_port   = 4002
  }

  tags {
    Name = "${var.app_name}"
  }
}

resource "aws_route53_record" "cog" {
  count   = "${var.domain_count}"
  name    = "${var.app_name}.${var.root_domain}"
  zone_id = "${var.route53_zone_id}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_elastic_beanstalk_environment.cog.cname}"]
}
