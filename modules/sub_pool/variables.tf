variable "pool_config" {
  type = object({
    cidr                 = list(string)
    ram_share_principals = optional(list(string))

    locale                            = optional(string)
    allocation_default_netmask_length = optional(string)
    allocation_max_netmask_length     = optional(string)
    allocation_min_netmask_length     = optional(string)
    auto_import                       = optional(string)
    aws_service                       = optional(string)
    description                       = optional(string)
    publicly_advertisable             = optional(bool)

    allocation_resource_tags   = optional(map(string))
    tags                       = optional(map(string))
    cidr_authorization_context = optional(map(string))

    sub_pools = optional(any)
  })
}

variable "implied_locale" {
  default = null
}

variable "implied_description" {
  default = null
}

variable "address_family" {}
variable "ipam_scope_id" {}
variable "source_ipam_pool_id" {}
