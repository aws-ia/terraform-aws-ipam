#####################################################################################
# Terraform module examples are meant to show an _example_ on how to use a module
# per use-case. The code below should not be copied directly but referenced in order
# to build your own root module that invokes this module
#####################################################################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.34"
    }
  }
}

variable "cidr" {
  default = "10.0.0.0/8"
}

locals {
  cidr = "10.0.0.0/8"
  # regional_cidrs = cidrsubnets(var.cidr, 8, 8, 8, 8)
}

module "ipv4_scope" {
  # source  = "aws-ia/ipam/aws"
  source = "../.."

  top_cidr = [var.cidr]

  pool_configurations = {
    us-west-2 = {
      cidr   = ["10.0.0.0/16"] # [local.regional_cidrs[0], local.regional_cidrs[1]]
      locale = "us-west-2"

      sub_pools = {
        sandbox = {
          cidr = ["10.0.0.0/20"]
          allocation_resource_tags = {
            env = "sandbox"
          }
        }
      }
    }
  }
}

resource "aws_vpc_ipam_scope" "scope_for_overlapping_cidr" {
  ipam_id     = module.ipv4_scope.ipam_info.id
  description = "Second private scope for overlapping cidr."
}

module "overlapping_cidr_second_ipv4_scope" {
  # source  = "aws-ia/ipam/aws"
  source = "../.."

  top_cidr      = [var.cidr]
  create_ipam   = false
  ipam_scope_id = aws_vpc_ipam_scope.scope_for_overlapping_cidr.id

  pool_configurations = {
    us-east-1 = {
      name        = "ipv6 us-east-1"
      description = "pool for ipv6 us-east-1"
      cidr        = "10.0.0.0/16" #[local.regional_cidrs[0]]
      locale      = "us-east-1"
    }
    us-west-2 = {
      description = "pool for ipv6 us-west-2"
      cidr        = "10.0.1.0/16" #[local.regional_cidrs[1]]
      locale      = "us-west-2"
    }
  }
}
