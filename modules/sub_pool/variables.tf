variable "pool_config" {
  description = "Configuration of the Pool you want to deploy. All aws_vpc_ipam_pool arguments are available as well as ram_share_principals list and sub_pools map (up to 3 levels)."
  type = object({
    cidr                 = optional(list(string))
    ram_share_principals = optional(list(string))

    locale                            = optional(string)
    allocation_default_netmask_length = optional(string)
    allocation_max_netmask_length     = optional(string)
    allocation_min_netmask_length     = optional(string)
    auto_import                       = optional(string)
    aws_service                       = optional(string)
    description                       = optional(string)
    name                              = optional(string)
    netmask_length                    = optional(number)
    publicly_advertisable             = optional(bool)
    public_ip_source                  = optional(string)

    allocation_resource_tags = optional(map(string))
    tags                     = optional(map(string))

    sub_pools = optional(any)
  })

  validation {
    condition = anytrue([
      (var.pool_config.cidr != null && var.pool_config.netmask_length == null),
      (var.pool_config.cidr == null && var.pool_config.netmask_length != null)
    ])
    error_message = "Pool Name: ${var.pool_config.name == null ? "Unamed" : var.pool_config.name} - must define exactly one of `cidr` or `netmask_length`."
  }
}

variable "cidr_authorization_contexts" {
  description = "A list of signed documents that proves that you are authorized to bring the specified IP address range to Amazon using BYOIP. Document is not stored in the state file. For more information, refer to https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool_cidr#cidr_authorization_context."
  type = list(object({
    cidr      = string
    message   = string
    signature = string
  }))
  default = []
}


variable "implied_locale" {
  description = "Locale is implied from a parent pool even if another is specified. Its not possible to set child pools to different locales."
  type        = string
  default     = "None"
}

variable "implied_description" {
  description = "Description is implied from the pool tree name <parent>/<child> unless specified on the pool_config."
  default     = null
  type        = string
}

variable "implied_name" {
  description = "Name is implied from the pool tree name <parent>/<child> unless specified on the pool_config."
  default     = null
  type        = string
}

variable "address_family" {
  description = "IPv4/6 address family."
  type        = string
}

variable "ipam_scope_id" {
  description = "IPAM Scope ID to attach the pool to."
  type        = string
}

variable "source_ipam_pool_id" {
  description = "IPAM parent pool ID to attach the pool to."
  type        = string
}
