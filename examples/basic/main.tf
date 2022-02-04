module "basic" {
  source   = "../.."
  top_cidr = "10.0.0.0/8"

  cidr_allocations   = ["10.0.64.0/20"]
  ipam_configuration = var.ipam_configuration

}
