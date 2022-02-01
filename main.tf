locals {
  # Example Pool Structure
  # Top  0 - super cidr
  # tier 1 - region
  # tier 2 - env
  # tier 3 - business unit

  tier_2_pool_names = flatten([for k, v in var.ipam_configuration : [for k2, _ in v.sub_pools : "${k}/${k2}"]])
  # 3rd tier is optional, determine which tier 2 pools have 3rd tier
  tier_2_pool_names_with_3rd_tier = [for _, v in local.tier_2_pool_names : v if try(var.ipam_configuration[split("/", v)[0]].sub_pools[split("/", v)[1]].sub_pools, null) != null]
  tier_3_pool_names               = flatten([for _, v in local.tier_2_pool_names_with_3rd_tier : [for _, v2 in keys(var.ipam_configuration[split("/", v)[0]].sub_pools[split("/", v)[1]].sub_pools) : "${v}/${v2}"]])

  # find all unique values where key = locale
  all_locales = distinct(compact(flatten(concat([for k, v in var.ipam_configuration : try(v.locale, null)],
    [for k, v in var.ipam_configuration : [for k2, v2 in v.sub_pools : try(v2.locale, null)]],
    [for k, v in local.tier_3_pool_names : try(var.ipam_configuration[split("/", v)[0]].sub_pools[split("/", v)[1]].sub_pools[split("/", v)[2]].locale, null)]
  ))))
  # its possible to pools in all regions except the primary, but we must pass the primary region
  # to aws_vpc_ipam.operating_regions.region_name
  operating_regions = distinct(concat(local.all_locales, [data.aws_region.current.name]))
}

data "aws_region" "current" {}

resource "aws_vpc_ipam" "main" {
  description = "IPAM with primary in ${data.aws_region.current.name}"

  dynamic "operating_regions" {
    for_each = toset(local.operating_regions)
    content {
      region_name = operating_regions.key
    }
  }
}

# TODO optional IPAM, byoipam_id
resource "aws_vpc_ipam_pool" "top" {
  address_family = "ipv4"
  ipam_scope_id  = aws_vpc_ipam.main.private_default_scope_id
}

resource "aws_vpc_ipam_pool_cidr" "top" {
  ipam_pool_id = aws_vpc_ipam_pool.top.id
  cidr         = var.top_cidr
}

module "tier_one" {
  source   = "./modules/sub_pool"
  for_each = var.ipam_configuration

  address_family      = var.address_family
  ipam_scope_id       = aws_vpc_ipam.main.private_default_scope_id
  source_ipam_pool_id = aws_vpc_ipam_pool.top.id

  pool_config         = var.ipam_configuration[each.key]
  implied_description = each.key

  depends_on = [
    aws_vpc_ipam_pool_cidr.top
  ]
}

module "tier_two" {
  source   = "./modules/sub_pool"
  for_each = toset(local.tier_2_pool_names)

  address_family      = var.address_family
  ipam_scope_id       = aws_vpc_ipam.main.private_default_scope_id
  source_ipam_pool_id = module.tier_one[split("/", each.key)[0]].pool.id

  pool_config         = var.ipam_configuration[split("/", each.key)[0]].sub_pools[split("/", each.key)[1]]
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
  ipam_scope_id  = aws_vpc_ipam.main.private_default_scope_id

  source_ipam_pool_id = module.tier_two[
    join("/", [split("/", each.key)[0], split("/", each.key)[1]])
  ].pool.id

  pool_config = var.ipam_configuration[split("/", each.key)[0]].sub_pools[split("/", each.key)[1]].sub_pools[split("/", each.key)[2]]

  implied_locale = module.tier_two[
    join("/", [split("/", each.key)[0], split("/", each.key)[1]])
  ].pool.locale
  implied_description = each.key

  depends_on = [
    module.tier_two
  ]
}
