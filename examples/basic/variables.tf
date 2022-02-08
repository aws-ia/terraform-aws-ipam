variable "pool_configurations" {}

variable "prod_account" {
  description = "Used for testing, prod account id"
}

variable "prod_ou_arn" {
  description = "arn of ou to share to prod accounts"
}

variable "dev_ou_arn" {
  description = "arn of ou to share to dev accounts"
}
