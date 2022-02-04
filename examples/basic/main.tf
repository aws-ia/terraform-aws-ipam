module "basic" {
  source = "../.."

  top_cidr = "10.0.0.0/8"

  # block IPAM from using these CIDRS
  # cidr_allocations = ["10.0.64.0/20"]
  ipam_configuration = {}
  # ipam_configuration = {
  #   us-east-1 = {
  #     description                   = "us-east-1 top level pool"
  #     cidr                          = ["10.0.0.0/16"]
  #     locale                        = "us-east-1"
  #     # allocation_min_netmask_length = 16

  #     sub_pools = {

  #       sandbox = {
  #         cidr                              = ["10.0.48.0/20"]
  #         # allocation_max_netmask_length     = 28
  #         # allocation_default_netmask_length = 28
  #         ram_share_principals              = [local.dev_ou_arn]
  #       }

  #       prod = {
  #         cidr = ["10.0.32.0/20"]

  #         sub_pools = {
  #           app_team_a = {
  #             cidr                 = ["10.0.32.0/28"]

  #             ram_share_principals = ["601584510932"] # prod account
  #           }
  #           app_team_b = {
  #             cidr                 = ["10.0.32.32/28"]
  #             ram_share_principals = ["601584510932"] # prod account
  #           }
  #         }
  #       }
  #     }
  #   }
  #   us-west-2 = {
  #     cidr                          = ["10.1.0.0/16"]

  #   }

  # }

}

data "aws_organizations_organization" "org" {}

data "aws_organizations_organizational_units" "ou" {
  parent_id = data.aws_organizations_organization.org.roots[0].id
}

locals {
  dev_ou_arn = one([
    for _, ou in data.aws_organizations_organizational_units.ou.children[*] :
    ou.arn if ou.name == "dev"
  ])
}
