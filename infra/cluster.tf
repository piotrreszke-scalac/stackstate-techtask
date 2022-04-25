module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.20.2"

  cluster_name    = local.name
  cluster_version = local.cluster_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  # Extend cluster security group rules
  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  eks_managed_node_groups = {
    group-1 = {
      min_size     = 0
      max_size     = 4
      desired_size = 1

      instance_types = ["t3.xlarge"]
      capacity_type  = "SPOT"
      subnet_ids     = [module.vpc.private_subnets[0]]
    }
    group-2 = {
      min_size     = 0
      max_size     = 4
      desired_size = 1

      instance_types = ["t3.xlarge"]
      capacity_type  = "SPOT"
      subnet_ids     = [module.vpc.private_subnets[1]]
    }
    group-3 = {
      min_size     = 0
      max_size     = 4
      desired_size = 1

      instance_types = ["t3.xlarge"]
      capacity_type  = "SPOT"
      subnet_ids     = [module.vpc.private_subnets[2]]
    }
  }
}

# download kubeconfig to connect to cluster
resource "null_resource" "write-kubeconfig" {
  depends_on = [
    module.eks
  ]

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ${local.region} --name ${local.name}"
    environment = {
      AWS_PROFILE = local.profile
      KUBECONFIG  = "${path.cwd}/kubeconfig"
    }
  }
}
