module "basic" {
  source   = "../.."
  top_cidr = "10.0.0.0/8"

  ipam_configuration = var.ipam_configuration

}

# Top level non-locale

# N mid-level pools non-locale

# n regional pools
# thes can be shared via RAM


