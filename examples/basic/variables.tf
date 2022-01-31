variable "ipam_configuration" {

}

variable "pool_keys" {
  default = ["allocation_default_netmask_length", "allocation_max_netmask_length",
    "allocation_min_netmask_length", "allocation_resource_tags", "auto_import", "aws_service",
  "cidr", "locale", "description"]
}
