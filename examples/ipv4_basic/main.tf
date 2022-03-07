# This configuration is described in README.md

module "basic" {
  source = "../.."

  top_cidr = ["10.0.0.0/8"]

  pool_configurations = {
    corporate-us-west-2 = {
      description = "2nd level, locale us-west-2 pool"
      cidr        = ["10.0.0.0/16", "10.1.0.0/16"]
      locale      = "us-west-2"

      sub_pools = {

        sandbox = {
          cidr                 = ["10.0.0.0/20"]
          ram_share_principals = var.sandbox_ou_arn
          allocation_resource_tags = {
            env = "sandbox"
          }
        }
        dev = {
          cidr = ["10.1.0.0/20"]

          sub_pools = {
            team_a = {
              cidr                 = ["10.1.0.0/24"]
              ram_share_principals = var.prod_account # prod account
            }

            team_b = {
              cidr                 = ["10.1.1.0/24"]
              ram_share_principals = var.prod_account # prod account
            }
          }
        }
        prod = {
          cidr = ["10.1.16.0/20"]

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
