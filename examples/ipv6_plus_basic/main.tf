module "basic_ipam" {
  source = "../ipv4_basic"

  prod_account   = var.prod_account
  prod_ou_arn    = var.prod_ou_arn
  sandbox_ou_arn = var.sandbox_ou_arn
}

module "ipv6_scope" {
  source = "../.."

  top_cidr       = [var.ipv6_cidr]
  address_family = "ipv6"
  create_ipam    = false
  ipam_scope_id  = module.basic_ipam.ipam_info.public_default_scope_id

  top_cidr_authorization_context = {
    message   = var.cidr_authorization_context_message
    signature = var.cidr_authorization_context_signature
  }

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
