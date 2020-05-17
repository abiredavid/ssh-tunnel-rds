module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "~> 1.72"
  azs                  = "${slice(data.aws_availability_zones.available.names, 0, 2)}"
  cidr                 = "${var.vpccidr}"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
  name                 = "${local.random_string}-${local.user}"

  enable_nat_gateway     = "true"
  single_nat_gateway     = "true"
  one_nat_gateway_per_az = "false"

  private_subnets = [
    "${cidrsubnet(var.vpccidr, 8, 10)}",
    "${cidrsubnet(var.vpccidr, 8, 11)}",
  ]

  public_subnets = [
    "${cidrsubnet(var.vpccidr, 8, 20)}",
    "${cidrsubnet(var.vpccidr, 8, 21)}",
  ]
}
