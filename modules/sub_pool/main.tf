resource "aws_vpc_ipam_pool" "sub" {
  address_family      = var.address_family
  ipam_scope_id       = var.ipam_scope_id
  source_ipam_pool_id = var.source_ipam_pool_id

  # TODO: var.pool_config.description or var.description
  description                       = var.pool_config.description
  locale                            = var.pool_config.locale == null ? var.implied_locale : var.pool_config.locale # try( )  # try(var.pool_config.locale, null)
  allocation_default_netmask_length = var.pool_config.allocation_default_netmask_length
  allocation_max_netmask_length     = var.pool_config.allocation_max_netmask_length
  allocation_min_netmask_length     = var.pool_config.allocation_min_netmask_length
  # allocation_resource_tags = try(var.pool_config.allocation_resource_tags, null)
  auto_import = var.pool_config.auto_import
  # aws_service = try(var.pool_config.aws_service, null)
}

resource "aws_vpc_ipam_pool_cidr" "sub" {
  ipam_pool_id = aws_vpc_ipam_pool.sub.id
  cidr         = var.pool_config.cidr

  # dynamic cidr_authorization_context {
  #     for_each = try(var.pool_config.cidr_authorization_context, null) == null ? {} : var.pool_config.cidr_authorization_context
  #     content {
  #       message = cidr_authorization_context.message
  #       signature = cidr_authorization_context.signature
  #     }

  # }
}


variable "address_family" {}
variable "description" { default = null}
variable "ipam_scope_id" {}
variable "source_ipam_pool_id" {}

