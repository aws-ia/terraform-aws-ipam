variable "prod_account" {
  description = "Used for testing, prod account id."
  type        = list(string)
  default     = null
}

variable "prod_ou_arn" {
  description = "arn of ou to share to prod accounts."
  type        = list(string)
  default     = null
}

variable "sandbox_ou_arn" {
  description = "arn of ou to share to sandbox accounts."
  type        = list(string)
  default     = null
}

variable "ipv6_cidr" {
  description = "Top CIDR IPv6."
}

variable "cidr_authorization_context_message" {
  description = "CIDR Authorization Context Message."
}

variable "cidr_authorization_context_signature" {
  description = "CIDR Authorization Context Signature."
}
