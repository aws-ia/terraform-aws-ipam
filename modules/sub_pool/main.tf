locals {
  description = var.pool_config.description == null ? var.implied_description : var.pool_config.description
}

resource "aws_vpc_ipam_pool" "sub" {
  address_family      = var.address_family
  ipam_scope_id       = var.ipam_scope_id
  source_ipam_pool_id = var.source_ipam_pool_id

  description                       = local.description
  locale                            = var.implied_locale == null ? var.pool_config.locale : var.implied_locale
  allocation_default_netmask_length = var.pool_config.allocation_default_netmask_length
  allocation_max_netmask_length     = var.pool_config.allocation_max_netmask_length
  allocation_min_netmask_length     = var.pool_config.allocation_min_netmask_length
  allocation_resource_tags          = var.pool_config.allocation_resource_tags
  auto_import                       = var.pool_config.auto_import
  aws_service                       = var.pool_config.aws_service
  publicly_advertisable             = var.pool_config.publicly_advertisable

  tags = var.pool_config.tags
}

resource "aws_vpc_ipam_pool_cidr" "sub" {
  for_each = toset(var.pool_config.cidr)

  ipam_pool_id = aws_vpc_ipam_pool.sub.id
  cidr         = each.key

  dynamic "cidr_authorization_context" {
    for_each = var.pool_config.cidr_authorization_context == null ? {} : var.pool_config.cidr_authorization_context
    content {
      message   = cidr_authorization_context.message
      signature = cidr_authorization_context.signature
    }
  }
}

resource "aws_ram_resource_share" "sub" {
  count = var.pool_config.ram_share_principals == null ? 0 : 1

  name = replace(var.implied_description, "/", "-")
}

resource "aws_ram_resource_association" "sub" {
  count = var.pool_config.ram_share_principals == null ? 0 : 1

  resource_arn       = aws_vpc_ipam_pool.sub.arn
  resource_share_arn = aws_ram_resource_share.sub[0].arn
}

resource "aws_ram_principal_association" "sub" {
  for_each = var.pool_config.ram_share_principals == null ? [] : toset(var.pool_config.ram_share_principals)

  principal          = each.key
  resource_share_arn = aws_ram_resource_share.sub[0].arn
}
