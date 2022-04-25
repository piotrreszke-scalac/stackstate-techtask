module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name = local.name
  cidr = local.vpc_cidr

  # assuming 3 azs here
  azs = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = local.private_subnets_cidrs
  public_subnets  = local.public_subnets_cidrs

  enable_nat_gateway     = true
  single_nat_gateway     = true # cost savings
  one_nat_gateway_per_az = false
}

