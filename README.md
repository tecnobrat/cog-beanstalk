# Terraform + Elastic Beanstalk for Cog

This project gives you a simple way to get cog running on beanstalk.
Simply clone down the repo, edit the tfvars file, and run terraform.

## Getting Started

 * Clone this repo
 * Install the [awsebcli](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-install.html)
 * `cd terraform`
 * `cp terraform.tfvars.example terraform.tfvars`
 * Edit `terraform.tfvars`
 * `terraform plan` to see the changes.
 * `terraform apply` to apply the changes.
 * `cd ..`
 * `eb init [--profile profilename]` and select the right region and environment
 * `eb deploy`

## Notes about the hostname.

You have two choices.

1) Deal with the DNS yourself, this means after terraform applies the changes you will need to create a CNAME record from the elastic beanstalk hostname to `cog.[yourdomain.com]`, you must still set `root_domain` in the `terraform.tfvars` correctly

2) In your `terraform.tfvars` file set `root_domain` and `route53_zone_id` correctly and adjust `domain_count` to `1`.  This requires your domain to be hosted by AWS on Route53.

## Configuring Cog

There is only one small difference to using the [official
docs](http://docs.operable.io/docs/installation) for configuring cog.

First, you need to find and ssh into your EC2 instance.  You will need
to check the amazon web console to get the IP.  SSH using `ssh ec2-user@[ip]`

Once in, you can use the `sudo docker ps` command to find the container
ID for the `operable/cog` container, and then get into it by using `sudo
docker exec -it [container-id] bash`.

You can then follow along with the rest of the documentation.
