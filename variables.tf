variable "pool_configurations" {
  description = "A multi-tier-nested map describing nested IPAM pools. Can nest up to 3 tiers with the top tier being outside the `pool_configurations`. This attribute is quite complex, see README.md for further explanation."
  type        = any
  default     = {}

  # its possible to write a pretty advanced validation here and its probably worth the time
  # validation {
  #   error_message = "value"
  #   condition = false
  # }
}

variable "top_cidr" {
  description = "Top tier cidr blocks."
  type        = list(string)
}

variable "top_ram_share_principals" {
  description = "Principals to create RAM shares for top tier pool."
  type        = list(string)
  default     = null
}

variable "top_cidr_allocations" {
  description = "cidr_allocations for top tier pool."
  type        = list(string)
  default     = []
}

variable "top_auto_import" {
  description = "`auto_import` setting for top tier pool."
  type        = bool
  default     = null
}

variable "top_description" {
  description = "Description of top tier pool."
  type        = string
  default     = ""
}

variable "top_tags" {
  description = "Tags for top tier pool."
  type        = map(string)
  default     = null
}

variable "address_family" {
  description = "IPv4/6 address family."
  type        = string
  default     = "ipv4"
}

variable "create_ipam" {
  description = "Determines whether or not to create an IPAM. If `false` you must also provide a var.ipam_scope_id"
  type        = bool
  default     = true
}

variable "ipam_scope_id" {
  description = "(Optional) Required if `var.ipam_id` is set. Which scope to deploy pools into."
  type        = string
  default     = null
}

variable "ipam_scope_type" {
  description = "Which scope type to use. Valid inputs: `public`, `private`. You can alternatively provide your own scope id."
  type        = string
  default     = "private"

  validation {
    condition     = var.ipam_scope_type == "public" || var.ipam_scope_type == "private"
    error_message = "Scope type must be either public or private."
  }
}

variable "cidr_allocations" {
  description = "List of cidrs to block IPAM from allocating. Uses the `aws_vpc_ipam_pool_cidr_allocation` resource."
  type        = list(string)
  default     = []
}
