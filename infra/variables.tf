locals {
  name     = "techtask"
  vpc_cidr = "10.61.0.0/16"

  # split cidr in half, for public and private part
  public_network_cidr  = cidrsubnet(local.vpc_cidr, 2, 0)
  private_network_cidr = cidrsubnet(local.vpc_cidr, 2, 1)

  # split each private/public cidr into 3 smaller ones, for each AZ
  private_subnets_cidrs = [cidrsubnet(local.private_network_cidr, 2, 0), cidrsubnet(local.private_network_cidr, 2, 1), cidrsubnet(local.private_network_cidr, 2, 2)]
  public_subnets_cidrs  = [cidrsubnet(local.public_network_cidr, 2, 0), cidrsubnet(local.public_network_cidr, 2, 1), cidrsubnet(local.public_network_cidr, 2, 2)]

  profile         = "scalac-piotrres"
  region          = "eu-central-1"
  cluster_version = "1.21"

  cnames = {
    "k8s.stackstate.scalac.io" : "a73e90d469f6042dcb9414fca48be9cd-1399008648.eu-central-1.elb.amazonaws.com", # this should be done using ExternalDNS
    "*.stackstate.scalac.io" : "k8s.stackstate.scalac.io"
  }
}
