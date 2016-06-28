resource "aws_iam_instance_profile" "cog" {
  name  = "${var.app_name}"
  roles = ["${aws_iam_role.cog.name}"]
}

resource "aws_iam_role" "cog" {
  name               = "${var.app_name}"
  assume_role_policy = "${file("policies/assume_role_ec2.json")}"
}

resource "aws_iam_role_policy" "cog_default_beanstalk" {
  name   = "${var.app_name}-default-beanstalk"
  role   = "${aws_iam_role.cog.id}"
  policy = "${template_file.cog_beanstalk_default.rendered}"
}

resource "aws_iam_role_policy" "cog_all_access" {
  name   = "${var.app_name}-all-access"
  role   = "${aws_iam_role.cog.id}"
  policy = "${file("policies/all-access.json")}"
}

resource "template_file" "cog_beanstalk_default" {
  template = "${file("policies/default_beanstalk.json")}"

  vars {
    account_id = "${var.aws_account_id}"
    aws_region = "${var.aws_region}"
  }
}

resource "aws_iam_role" "cog_beanstalk_service" {
  name               = "cog-beanstalk-service-role"
  assume_role_policy = "${file("policies/assume_role_beanstalk.json")}"
}

resource "aws_iam_role_policy" "cog_beanstalk_enhanced_health" {
  name   = "beanstalk-enhanced-health"
  role   = "${aws_iam_role.cog_beanstalk_service.name}"
  policy = "${file("policies/beanstalk_enhanced_health.json")}"
}
