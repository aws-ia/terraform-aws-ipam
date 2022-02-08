# This configuration is described in README.md

module "basic" {
  source = "../.."

  top_cidr = ["10.0.0.0/8"]

  pool_configurations = {
    us-west-2 = {
      description = "us-west-2 top level pool"
      cidr        = ["10.0.0.0/16"]
      locale      = "us-west-2"

      sub_pools = {

        sandbox = {
          cidr                 = ["10.0.48.0/20"]
          ram_share_principals = [var.dev_ou_arn]
        }

        prod = {
          cidr = ["10.0.32.0/20"]

          sub_pools = {
            team_a = {
              cidr                 = ["10.0.32.0/28"]
              ram_share_principals = [var.prod_account] # prod account
            }

            team_b = {
              cidr                 = ["10.0.32.32/28"]
              ram_share_principals = [var.prod_account] # prod account
            }
          }
        }
      }
    }
    us-east-1 = {
      cidr   = ["10.1.0.0/16"]
      locale = "us-east-1"

      sub_pools = {

        team_a = {
          cidr                 = ["10.1.48.0/20"]
          ram_share_principals = [var.prod_ou_arn]
        }

        team_b = {
          cidr                 = ["10.1.64.0/20"]
          ram_share_principals = [var.prod_ou_arn]
        }
      }
    }
  }
}
