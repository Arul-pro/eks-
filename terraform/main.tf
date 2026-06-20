terraform {
  required_version = ">= 1.15.0" # Cleanly matches your local v1.15.6 environment
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "existing" {
  id = var.vpc_id
}

data "aws_subnets" "existing" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  cluster_endpoint_public_access = true

  vpc_id     = data.aws_vpc.existing.id
  subnet_ids = data.aws_subnets.existing.ids

  eks_managed_node_groups = {
    micro_nodes = {
      min_size       = 2  # Increased to split core components across nodes
      max_size       = 4
      desired_size   = 2  
      instance_types = var.node_instance_types

      # Crucial for micro instances: forces smaller kubelet allocations
      kubelet_extra_args = "--kube-reserved=cpu=50m,memory=100Mi --system-reserved=cpu=50m,memory=100Mi"
    }
  }

  enable_cluster_creator_admin_permissions = true
}