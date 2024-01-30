variable "pool_configurations" {
  type        = any
  default     = {}
  description = <<-EOF
  A multi-level, nested map describing nested IPAM pools. Can nest up to three levels with the top level being outside the `pool_configurations` in vars prefixed `top_`. If arugument descriptions are omitted, you can find them in the [official documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool#argument-reference).

  - `ram_share_principals` = (optional, list(string)) of valid organization principals to create ram shares to.
  - `name`                 = (optional, string) name to give the pool, the key of your map in var.pool_configurations will be used if omitted.
  - `description`          = (optional, string) description to give the pool, the key of your map in var.pool_configurations will be used if omitted.
  - `cidr`                 = (optional, list(string)) list of CIDRs to provision into pool. Conflicts with `netmask_length`.
  - `netmask_length`       = (optional, number) netmask length to request provisioned into pool. Conflicts with `cidr`.

  - `locale`      = (optional, string) locale to set for pool.
  - `auto_import` = (optional, string)
  - `tags`        = (optional, map(string))
  - `allocation_default_netmask_length` = (optional, string)
  - `allocation_max_netmask_length`     = (optional, string)
  - `allocation_min_netmask_length`     = (optional, string)
  - `allocation_resource_tags`          = (optional, map(string))

  The following arguments are available but only relevant for public ips
  - `cidr_authorization_context` = (optional, map(string)) Details found in [official documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool_cidr#cidr_authorization_context).
  - `aws_service`                = (optional, string)
  - `publicly_advertisable`      = (optional, bool)

  - `sub_pools` = (nested repeats of pool_configuration object above)
EOF
}

variable "top_cidr" {
  description = "Top-level CIDR blocks."
  type        = list(string)
  default     = null
}

variable "top_netmask_length" {
  description = "Top-level netmask length to request. Not possible to use for IPv4. Only possible to use with amazon provided ipv6."
  type        = number
  default     = null
}

variable "top_ram_share_principals" {
  description = "Principals to create RAM shares for top-level pool."
  type        = list(string)
  default     = null
}

variable "top_auto_import" {
  description = "`auto_import` setting for top-level pool."
  type        = bool
  default     = null
}

variable "top_description" {
  description = "Description of top-level pool."
  type        = string
  default     = ""
}

variable "top_name" {
  description = "Name of top-level pool."
  type        = string
  default     = null
}

variable "top_cidr_authorization_contexts" {
  description = "CIDR must match a CIDR defined in `var.top_cidr`. A list of signed documents that proves that you are authorized to bring the specified IP address range to Amazon using BYOIP. Document is not stored in the state file. For more information, refer to https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool_cidr#cidr_authorization_context."
  type = list(object({
    cidr      = string
    message   = string
    signature = string
  }))
  default = []
}

variable "top_public_ip_source" {
  description = "public IP source for usage with public IPs. Valid values \"amazon\" or \"byoip\"."
  type        = string
  default     = null
}

variable "top_publicly_advertisable" {
  description = "Whether or not the top-level pool is publicly advertisable."
  type        = bool
  default     = null
}

variable "top_aws_service" {
  description = "AWS service, for usage with public IPs. Valid values \"ec2\"."
  type        = string
  default     = null
}

variable "top_locale" {
  description = "locale of the top-level pool. Do not use this value unless building an ipv6 contiguous block pool. You will have to instantiate the module for each operating region you want a pool structure in."
  type        = string
  default     = null
}

variable "address_family" {
  description = "IPv4/6 address family."
  type        = string
  default     = "ipv4"
  validation {
    condition     = var.address_family == "ipv4" || var.address_family == "ipv6"
    error_message = "Only valid options: \"ipv4\", \"ipv6\"."
  }
}

variable "create_ipam" {
  description = "Determines whether to create an IPAM. If `false`, you must also provide a var.ipam_scope_id."
  type        = bool
  default     = true
}

variable "ipam_scope_id" {
  description = "(Optional) Required if `var.ipam_id` is set. Determines which scope to deploy pools into."
  type        = string
  default     = null
}

variable "ipam_scope_type" {
  description = "Which scope type to use. Valid inputs include `public` or `private`. You can alternatively provide your own scope ID."
  type        = string
  default     = "private"

  validation {
    condition     = var.ipam_scope_type == "public" || var.ipam_scope_type == "private"
    error_message = "Scope type must be either public or private."
  }
}
