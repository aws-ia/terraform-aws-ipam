locals {
  description = var.pool_config.description == null ? replace(var.implied_description, "/", "-") : var.pool_config.description

  name = var.pool_config.name == null ? var.implied_name : var.pool_config.name
  tags = merge(var.pool_config.tags, {
    Name = local.name }
  )

  ram_share_enabled = try(length(var.pool_config.ram_share_principals), 0) > 0
}

resource "aws_vpc_ipam_pool" "sub" {
  address_family      = var.address_family
  ipam_scope_id       = var.ipam_scope_id
  source_ipam_pool_id = var.source_ipam_pool_id

  description                       = local.description
  locale                            = var.implied_locale != "None" ? var.implied_locale : var.pool_config.locale
  allocation_default_netmask_length = var.pool_config.allocation_default_netmask_length
  allocation_max_netmask_length     = var.pool_config.allocation_max_netmask_length
  allocation_min_netmask_length     = var.pool_config.allocation_min_netmask_length
  allocation_resource_tags          = var.pool_config.allocation_resource_tags
  auto_import                       = var.pool_config.auto_import
  aws_service                       = var.pool_config.aws_service
  publicly_advertisable             = var.pool_config.publicly_advertisable

  tags = local.tags
}

resource "aws_vpc_ipam_pool_cidr" "sub" {
  for_each = toset(var.pool_config.cidr)

  ipam_pool_id = aws_vpc_ipam_pool.sub.id
  cidr         = each.key

  dynamic "cidr_authorization_context" {
    for_each = var.pool_config.cidr_authorization_context == null ? [] : [1]
    content {
      message   = var.pool_config.cidr_authorization_context.message
      signature = var.pool_config.cidr_authorization_context.signature
    }
  }
}

resource "aws_ram_resource_share" "sub" {
  count = local.ram_share_enabled ? 1 : 0

  # if a user specifies a var.pool.description must validate there is no / which is invalid for RAM names
  name = replace(local.description, "/", "-")

  tags = local.tags
}

resource "aws_ram_resource_association" "sub" {
  count = local.ram_share_enabled ? 1 : 0

  resource_arn       = aws_vpc_ipam_pool.sub.arn
  resource_share_arn = aws_ram_resource_share.sub[0].arn
}

resource "aws_ram_principal_association" "sub" {
  for_each = local.ram_share_enabled ? toset(var.pool_config.ram_share_principals) : []

  principal          = each.key
  resource_share_arn = aws_ram_resource_share.sub[0].arn
}
