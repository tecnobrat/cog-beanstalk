# Terraform + Elastic Beanstalk for Cog

This project gives you a simple way to get cog running on beanstalk.
Simply clone down the repo, edit the tfvars file, and run terraform.

## Getting Started

 * Clone this repo
 * Install the AWS CLI
 * `cp terraform.tfvars.example terraform.tfvars`
 * Edit `terraform.tfvars`
 * `terraform plan` to see the changes.
 * `terraform apply` to apply the changes.
 * -Command to run eb deploy-

## Notes about the hostname.

You have two choices.

1) Deal with the DNS yourself, this means after terraform applies the changes you will need to create a CNAME record from the elastic beanstalk hostname to `cog.[yourdomain.com]`, you must still set `root_domain` in the `terraform.tfvars` correctly

2) In your `terraform.tfvars` file set `root_domain` and `route53_zone_id` correctly and adjust `domain_count` to `1`.  This requires your domain to be hosted by AWS on Route53.
