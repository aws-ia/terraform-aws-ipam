variable "ipam_configuration" {
  description = "A multi-tier-nested map describing nested IPAM pools. Can nest up to 3 tiers with the top tier being outside the `ipam_configuration`. This attribute is quite complex, see README.md for further explanation."
  type        = any #map(map(map(string)))

  # its possible to write a pretty advanced validation here and its probably worth the time
  # validation {
  #   error_message = "value"
  #   condition = false
  # }
}

variable "top_cidr" {
  description = "Top level cidr block"
  type        = string
  default     = null
}

variable "address_family" {
  description = "IPv4/6 address family."
  type        = string
  default     = "ipv4"
}
