variable "pool_config" {
  type = object({
    cidr = string
    locale = optional(string)
    allocation_default_netmask_length = optional(string)
    allocation_max_netmask_length = optional(string)
    allocation_min_netmask_length = optional(string)
    allocation_resource_tags = optional(map(string))
    auto_import = optional(string)
    aws_service = optional(string)
    description = optional(string)
    publicly_advertisable = optional(bool)

    sub_pools = optional(any)
  })
}

variable "implied_locale" {
  default = null
}

variable "implied_description" {
  default = null
}
