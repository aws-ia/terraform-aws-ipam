variable "pool_config" {
  type = object({
    cidr = string
    locale = optional(string)
    allocation_default_netmask_length = optional(string)
    allocation_max_netmask_length = optional(string)
    allocation_min_netmask_length = optional(string)
    # allocation_resource_tags = optional(string)
    auto_import = optional(string)
    aws_service = optional(string)
    description = optional(string)

    sub_pool = optional(any)
  })
}

variable "implied_locale" {
  default = null
}
