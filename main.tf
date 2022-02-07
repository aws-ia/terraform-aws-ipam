locals {
  # Example Pool Structure
  # Top  0 - super cidr
  # tier 1 - region
  # tier 2 - env
  # tier 3 - business unit

  # if create_ipam is true use determine if public or private default scope should be used. if create_ipam is false use `var.ipam_scope_id`
  scope_id = var.create_ipam ? (
    var.ipam_scope_type == "private" ? aws_vpc_ipam.main[0].private_default_scope_id : aws_vpc_ipam.main[0].public_default_scope_id
  ) : var.ipam_scope_id

  # pool names in 2nd tier expressed as parent/child
  tier_2_pool_names = compact(flatten([for k, v in var.pool_configurations : try([for k2, _ in v.sub_pools : "${k}/${k2}"], null)]))
  # 3rd tier is optional, determine which tier 2 pools have 3rd tier
  tier_2_pool_names_with_3rd_tier = [for _, v in local.tier_2_pool_names : v if try(var.pool_configurations[split("/", v)[0]].sub_pools[split("/", v)[1]].sub_pools, null) != null]
  tier_3_pool_names               = flatten([for _, v in local.tier_2_pool_names_with_3rd_tier : [for _, v2 in keys(var.pool_configurations[split("/", v)[0]].sub_pools[split("/", v)[1]].sub_pools) : "${v}/${v2}"]])

  # find all unique values where key = locale
  all_locales = distinct(compact(flatten(concat([for k, v in var.pool_configurations : try(v.locale, null)],
    [for k, v in var.pool_configurations : try([for k2, v2 in v.sub_pools : try(v2.locale, null)], null)],
    [for k, v in local.tier_3_pool_names : try(var.pool_configurations[split("/", v)[0]].sub_pools[split("/", v)[1]].sub_pools[split("/", v)[2]].locale, null)]
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
}

module "tier_zero" {
  source = "./modules/sub_pool"

  address_family      = var.address_family
  ipam_scope_id       = local.scope_id
  source_ipam_pool_id = null

  pool_config = {
    cidr                 = var.top_cidr
    ram_share_principals = var.top_ram_share_principals
    auto_import          = var.top_auto_import
    description          = var.top_description
    tags                 = {}
  }
}

module "tier_one" {
  source   = "./modules/sub_pool"
  for_each = var.pool_configurations

  address_family      = var.address_family
  ipam_scope_id       = local.scope_id
  source_ipam_pool_id = module.tier_zero.pool.id

  pool_config         = var.pool_configurations[each.key]
  implied_description = each.key

  depends_on = [
    module.tier_zero
  ]
}

module "tier_two" {
  source   = "./modules/sub_pool"
  for_each = toset(local.tier_2_pool_names)

  address_family      = var.address_family
  ipam_scope_id       = local.scope_id
  source_ipam_pool_id = module.tier_one[split("/", each.key)[0]].pool.id

  pool_config         = var.pool_configurations[split("/", each.key)[0]].sub_pools[split("/", each.key)[1]]
  implied_locale      = module.tier_one[split("/", each.key)[0]].pool.locale
  implied_description = each.key

  depends_on = [
    module.tier_one
  ]
}

module "tier_three" {
  source   = "./modules/sub_pool"
  for_each = toset(local.tier_3_pool_names)

  address_family = var.address_family
  ipam_scope_id  = local.scope_id

  source_ipam_pool_id = module.tier_two[
    join("/", [split("/", each.key)[0], split("/", each.key)[1]])
  ].pool.id

  pool_config = var.pool_configurations[split("/", each.key)[0]].sub_pools[split("/", each.key)[1]].sub_pools[split("/", each.key)[2]]

  implied_locale = module.tier_two[
    join("/", [split("/", each.key)[0], split("/", each.key)[1]])
  ].pool.locale
  implied_description = each.key

  depends_on = [
    module.tier_two
  ]
}
