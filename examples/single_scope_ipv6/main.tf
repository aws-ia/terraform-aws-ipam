#####################################################################################
# Terraform module examples are meant to show an _example_ on how to use a module
# per use-case. The code below should not be copied directly but referenced in order
# to build your own root module that invokes this module
#####################################################################################

module "ipv6_basic" {
  # source  = "aws-ia/ipam/aws"
  source = "../.."

  top_cidr        = [var.ipv6_cidr]
  address_family  = "ipv6"
  ipam_scope_type = "public"

  top_cidr_authorization_contexts = [{
    cidr      = var.cidr_authorization_context_cidr
    message   = var.cidr_authorization_context_message
    signature = var.cidr_authorization_context_signature
  }]

  pool_configurations = {
    us-east-1 = {
      name        = "ipv6 us-east-1"
      description = "pool for ipv6 us-east-1"
      cidr        = cidrsubnets(var.ipv6_cidr, 2)
      locale      = "us-east-1"

      sub_pools = {
        team_a = {
          name = "team_a"
          cidr = [join("/", [split("/", cidrsubnets(var.ipv6_cidr, 2)[0])[0], "56"])]
        }
      }
    }
    us-west-2 = {
      description = "pool for ipv6 us-west-2"
      cidr        = [cidrsubnets(var.ipv6_cidr, 2, 2)[1]]
      locale      = "us-west-2"
    }
  }
}
