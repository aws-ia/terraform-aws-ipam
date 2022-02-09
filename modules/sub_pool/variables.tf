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

  # Not currently used due to:
  # https://github.com/hashicorp/terraform/issues/29204#issuecomment-1034076226
  # validation {
  #   condition = alltrue([ for _, k in keys(var.pool_config) :
  #     contains(["cidr", "locale", "ram_share_principals", "auto_import", "aws_service", "description",
  #               "publicly_advertisable", "allocation_resource_tags", "tags", "cidr_authorization_context",
  #                "sub_pools", "allocation_default_netmask_length", "allocation_max_netmask_length",
  #                "allocation_min_netmask_length"], k) ])

  #   error_message = "Can only accept certain parameters. See modules/sub_pool/variables.tf for `pool_config` options."
  # }
}

variable "implied_locale" {
  description = "Locale is implied from a parent pool even if another is specified. Its not possible to set child pools to different locales."
  type        = string
  default     = null
}

variable "implied_description" {
  description = "Description is implied from the pool tree name <parent>/<child> unless specified on the pool_config."
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
