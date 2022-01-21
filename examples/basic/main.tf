module "basic" {
  source = "../.."

  ipam_configuration = {
    top_tier_cidr = "10.0.0.0/8"
    prod = {
        mid_tier_cidr = "10.0.0.0/16"
        us-west-2 = {
          cidr = "10.0.0.0/28"
        }
    }
    sandbox = {
        mid_tier_cidr = "10.1.0.0/16"
        us-west-2 = {
          cidr = "10.1.0.0/28"
        }
    }
  }

}
