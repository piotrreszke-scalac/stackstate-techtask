provider "aws" {
  region  = local.region
  profile = local.profile
}

data "aws_availability_zones" "available" {
}
