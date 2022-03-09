variable "prod_account" {
  description = "Used for testing, prod account id"
  type        = list(string)
}

variable "prod_ou_arn" {
  description = "arn of ou to share to prod accounts"
  type        = list(string)
}

variable "sandbox_ou_arn" {
  description = "arn of ou to share to sandbox accounts"
  type        = list(string)
}
