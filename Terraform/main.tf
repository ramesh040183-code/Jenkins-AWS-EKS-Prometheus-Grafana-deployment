terraform {
        required_version = "~> 1.0"
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"     
        }
    }
}

provider "aws" {
    region = var.aws_region  
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.vpc_cidr

  azs             = [var.availability_zone_1, var.availability_zone_2]
  public_subnets  = [var.subnet1_cidr, var.subnet2_cidr]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  map_public_ip_on_launch = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "my-cluster"
  kubernetes_version = "1.33"

  addons = {
    coredns                = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy             = {}
    vpc-cni                = {
      before_compute = true
    }
  }

  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.public_subnets
  

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    mynods = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = [var.instance_type]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

