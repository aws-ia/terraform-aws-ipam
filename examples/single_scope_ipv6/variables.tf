variable "ipv6_cidr" {
  description = "Top CIDR IPv6."
}

variable "cidr_authorization_context_message" {
  description = "CIDR Authorization Context Message."
}

variable "cidr_authorization_context_signature" {
  description = "CIDR Authorization Context Signature."
}

variable "cidr_authorization_context_cidr" {
  description = "CIDR Authorization Context CIDR. MUST MATCH a cidr in var.ipv6_cidr"
}
