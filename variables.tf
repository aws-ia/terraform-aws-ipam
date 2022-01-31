variable "ipam_configuration" {
  # type = map(map(object({
  #         cidr = string
  #         allocation_default_netmask_length = optional(string)
  #         allocation_max_netmask_length = optional(string)
  #         allocation_min_netmask_length = optional(string)
  #         allocation_resource_tags = optional(map(string))
  #         auto_import = optional(map(string))
  #         description = optional(string)
  #         shared_to_accounts = optional(list(string))
  #         tags = optional(map(string))
  # })))
  type = any #map(map(map(string)))
}

variable "top_cidr" {
  description = "Top level cidr block"
  type        = string
  default     = null
}

variable "address_family" {
  default = "ipv4"
}
