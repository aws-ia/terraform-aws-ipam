variable "pool_config" {
  description = "Configuration of the Pool you want to deploy. All aws_vpc_ipam_pool arguments are available as well as ram_share_principals list and sub_pools map (up to 3 levels)."
  type = object({
    cidr                 = list(string)
    ram_share_principals = optional(list(string))
    create_scp           = optional(bool, false)

    locale                            = optional(string)
    allocation_default_netmask_length = optional(string)
    allocation_max_netmask_length     = optional(string)
    allocation_min_netmask_length     = optional(string)
    auto_import                       = optional(string)
    aws_service                       = optional(string)
    description                       = optional(string)
    name                              = optional(string)
    publicly_advertisable             = optional(bool)

    allocation_resource_tags   = optional(map(string))
    tags                       = optional(map(string))
    cidr_authorization_context = optional(map(string))

    sub_pools = optional(any)
  })

  # Validation to ensure keys
  # if specify type = object() keys are silently dropped, no validation required but also no error if improper keys
  # if speicy type = any we can validate which provides an error opportunity BUT values are not defaulted, makes code complex
  # validation {
  #   condition = (length(setsubtract(keys(var.pool_config), [
  #                 "name", "cidr", "locale", "ram_share_principals", "auto_import", "aws_service", "description",
  #                 "publicly_advertisable", "allocation_resource_tags", "tags", "cidr_authorization_context",
  #                 "sub_pools", "allocation_default_netmask_length", "allocation_max_netmask_length",
  #                 "allocation_min_netmask_length"]
  #                )) == 0)
  #   error_message = "Can only accept certain parameters. See modules/sub_pool/variables.tf for `pool_config` options."
  # }
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
