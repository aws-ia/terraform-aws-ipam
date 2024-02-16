#####################################################################################
# Terraform module examples are meant to show an _example_ on how to use a module
# per use-case. The code below should not be copied directly but referenced in order
# to build your own root module that invokes this module
#####################################################################################

module "basic" {
  # source  = "aws-ia/ipam/aws"
  source = "../.."

  top_cidr = ["10.0.0.0/8"]
  top_name = "basic ipam"

  ipam_pool_configurations = {
    corporate-us-west-2 = {
      description = "2nd level, locale us-west-2 pool"
      cidr        = ["10.0.0.0/16", "10.1.0.0/16"]

      sub_pools = {

        sandbox = {
          name                 = "mysandbox"
          cidr                 = ["10.0.0.0/20"]
          ram_share_principals = var.sandbox_ou_arn
          allocation_resource_tags = {
            env = "sandbox"
          }
        }
        dev = {
          netmask_length = 20

          sub_pools = {
            team_a = {
              netmask_length       = 24
              ram_share_principals = var.prod_account # prod account
              locale               = "us-west-2"
            }

            team_b = {
              netmask_length       = 26
              ram_share_principals = var.prod_account # prod account
            }
          }
        }
        prod = {
          cidr   = ["10.1.16.0/20"]
          locale = "us-west-2"

          sub_pools = {
            team_a = {
              cidr                 = ["10.1.16.0/24"]
              ram_share_principals = var.prod_account # prod account
            }

            team_b = {
              cidr                 = ["10.1.17.0/24"]
              ram_share_principals = var.prod_account # prod account
            }
          }
        }
      }
    }
    us-east-1 = {
      cidr   = ["10.2.0.0/16"]
      locale = "us-east-1"

      sub_pools = {

        team_a = {
          cidr                 = ["10.2.0.0/20"]
          ram_share_principals = var.prod_ou_arn
        }

        team_b = {
          cidr                 = ["10.2.16.0/20"]
          ram_share_principals = var.prod_ou_arn
        }
      }
    }
  }
}
