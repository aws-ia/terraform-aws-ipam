locals {
  # if create_ipam is true use determine if public or private default scope should be used. if create_ipam is false use `var.ipam_scope_id`
  scope_id = var.create_ipam ? (
    var.ipam_scope_type == "private" ? aws_vpc_ipam.main[0].private_default_scope_id : aws_vpc_ipam.main[0].public_default_scope_id
  ) : var.ipam_scope_id

  level_1_pool_names = [for k, v in var.pool_configurations : k]
  # pool names in 2nd level expressed as parent/child
  level_2_pool_names = compact(flatten([for k, v in var.pool_configurations : try([for k2, _ in v.sub_pools : "${k}/${k2}"], null)]))
  # 3rd level is optional, determine which level 2 pools have 3rd level
  level_2_pool_names_with_3rd_level = [for _, v in local.level_2_pool_names : v if try(var.pool_configurations[split("/", v)[0]].sub_pools[split("/", v)[1]].sub_pools, null) != null]
  level_3_pool_names                = flatten([for _, v in local.level_2_pool_names_with_3rd_level : [for _, v2 in keys(var.pool_configurations[split("/", v)[0]].sub_pools[split("/", v)[1]].sub_pools) : "${v}/${v2}"]])

  # find all unique values where key = locale
  all_locales = distinct(compact(flatten(concat([for k, v in var.pool_configurations : try(v.locale, null)],
    [for k, v in var.pool_configurations : try([for k2, v2 in v.sub_pools : try(v2.locale, null)], null)],
    [for k, v in local.level_3_pool_names : try(var.pool_configurations[split("/", v)[0]].sub_pools[split("/", v)[1]].sub_pools[split("/", v)[2]].locale, null)]
  ))))

  # its possible to create pools in all regions except the primary, but we must pass the primary region
  # to aws_vpc_ipam.operating_regions.region_name
  operating_regions = distinct(concat(local.all_locales, [data.aws_region.current.name]))
}

data "aws_region" "current" {}

resource "aws_vpc_ipam" "main" {
  count = var.create_ipam ? 1 : 0

  description = "IPAM with primary in ${data.aws_region.current.name}"

  dynamic "operating_regions" {
    for_each = toset(local.operating_regions)
    content {
      region_name = operating_regions.key
    }
  }

  tags = var.tags
}

module "level_zero" {
  source = "./modules/sub_pool"
  providers = {
    aws.root = aws.root
  }
  address_family      = var.address_family
  ipam_scope_id       = local.scope_id
  source_ipam_pool_id = null

  pool_config = {
    cidr                       = var.top_cidr
    ram_share_principals       = var.top_ram_share_principals
    auto_import                = var.top_auto_import
    description                = var.top_description
    cidr_authorization_context = var.top_cidr_authorization_context
    name                       = var.top_name
  }
}

module "level_one" {
  source   = "./modules/sub_pool"
  for_each = var.pool_configurations
  providers = {
    aws.root = aws.root
  }
  address_family      = var.address_family
  ipam_scope_id       = local.scope_id
  source_ipam_pool_id = module.level_zero.pool.id

  pool_config         = var.pool_configurations[each.key]
  implied_description = each.key
  implied_name        = each.key

  depends_on = [
    module.level_zero
  ]
}

module "level_two" {
  source   = "./modules/sub_pool"
  for_each = toset(local.level_2_pool_names)
  providers = {
    aws.root = aws.root
  }
  address_family      = var.address_family
  ipam_scope_id       = local.scope_id
  source_ipam_pool_id = module.level_one[split("/", each.key)[0]].pool.id

  pool_config         = var.pool_configurations[split("/", each.key)[0]].sub_pools[split("/", each.key)[1]]
  implied_locale      = module.level_one[split("/", each.key)[0]].pool.locale
  implied_description = each.key
  implied_name        = each.key

  depends_on = [
    module.level_one
  ]
}

module "level_three" {
  source   = "./modules/sub_pool"
  for_each = toset(local.level_3_pool_names)
  providers = {
    aws.root = aws.root
  }
  address_family = var.address_family
  ipam_scope_id  = local.scope_id

  source_ipam_pool_id = module.level_two[
    join("/", [split("/", each.key)[0], split("/", each.key)[1]])
  ].pool.id

  pool_config = var.pool_configurations[split("/", each.key)[0]].sub_pools[split("/", each.key)[1]].sub_pools[split("/", each.key)[2]]

  implied_locale = module.level_two[
    join("/", [split("/", each.key)[0], split("/", each.key)[1]])
  ].pool.locale
  implied_description = each.key
  implied_name        = each.key

  depends_on = [
    module.level_two
  ]
}
