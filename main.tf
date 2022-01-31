locals {

  # Pools
  # Top  0 - super cidr
  # tier 1 - region
  # tier 2 - env
  # tier 3 - business unit


  # optional_pool_keys = ["allocation_default_netmask_length", "allocation_max_netmask_length",
  #   "allocation_min_netmask_length", "allocation_resource_tags", "auto_import", "aws_service",
  # "locale", "description"]

  # mid pools without the top_tier_cidr
  # tier_1_pool_names = [for k, v in var.ipam_configuration : k]
  tier_2_pool_names = flatten([ for k, v in var.ipam_configuration : [for k2, _ in v.sub_pools : "${k}/${k2}"]]) # if !contains(var.pool_keys, k2)
  tier_2_pool_names_with_3rd_tier = [ for _, v in local.tier_2_pool_names  : v if try(var.ipam_configuration[split("/", v)[0]].sub_pools[split("/", v)[1]].sub_pools, null) != null ]
  tier_3_pool_names = flatten([ for _, v in local.tier_2_pool_names_with_3rd_tier : [for k2, v2 in keys(lookup(var.ipam_configuration, split("/", v)[0], null).sub_pools[split("/", v)[1]].sub_pools): "${v}/${v2}"]])

# [ for _, v in ["onea/testa", "onea/twoa"] : [for k2, v2 in keys(lookup(var.ipam_configuration, split("/", v)[0], null).sub_pools[split("/", v)[1]].sub_pools): "${v}/${v2}"]]

  # tier_3_pool_names = compact(flatten([ for _, v in local.tier_2_pool_names : try(keys(var.ipam_configuration[split("/", v)[0]].sub_pools[split("/", v)[1]].sub_pools), null) ]))


# [ for _, v in [ "onea/testa", "onea/twoa", "oneb/twob",]  : [ for k2, v2 in lookup(var.ipam_configuration, split("/", v)[0], null).sub_pools[split("/", v)[1]] : k2 ] ]
# [
#   [
#     "cidr",
#     "locale",
#     "sub_pools",
#   ],
#   [
#     "cidr",
#     "sub_pools",
#   ],
#   [
#     "cidr",
#     "locale",
#   ],
# ]


  # regional_pools = flatten([for mid, regions in local.list_regions_per_mid_pool : [for _, region in regions: "${mid}/${region}"]])


  #{for k, v in var.ipam_configuration : k => v if k != "top_tier_cidr"}


  # # names of the mid_tier_pools
  # mid_tier_pool_names = keys(local.mid_tier_pools)
  # # each mid_tier_pool_name with a list of regional pools to create
  # list_regions_per_mid_pool = {for mid_name, mid_v in local.mid_tier_pools : mid_name => [for i, v2 in mid_v : i if i != "mid_tier_cidr"]}
  # # list of all operating regions declared in ipam_configuration, used to set ipam.operating_regions
  # operating_regions = toset(concat(flatten(values(local.list_regions_per_mid_pool)), [data.aws_region.current.name] ))
  # # list of all regional pools to be created formatted `<mid_tier_pool_name>/region`
  # regional_pools = flatten([for mid, regions in local.list_regions_per_mid_pool : [for _, region in regions: "${mid}/${region}"]])
}

data "aws_region" "current" {}

resource "aws_vpc_ipam" "main" {
  description = "IPAM with primary in ${data.aws_region.current.name}"
  operating_regions {
    region_name = "us-east-1"
  }
  operating_regions {
    region_name = "us-west-2"
  }
  # dynamic operating_regions {
  #   for_each = # [data.aws_region.current.name] #local.operating_regions
  #   content {
  #     region_name = operating_regions.key
  #   }
  # }
}

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

  pool_config = var.ipam_configuration[each.key]

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

  pool_config = var.ipam_configuration[split("/", each.key)[0]].sub_pools[split("/", each.key)[1]]
  implied_locale = module.tier_one[split("/", each.key)[0]].pool.locale
  implied_description = each.key

  depends_on = [
    module.tier_one
  ]
}

module "tier_three" {
  source   = "./modules/sub_pool"
  for_each = toset(local.tier_3_pool_names)

  address_family      = var.address_family
  ipam_scope_id       = aws_vpc_ipam.main.private_default_scope_id

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

output "pool" {
  value = local.tier_3_pool_names
}


# description                       = try(var.ipam_configuration[each.key].description, each.key)
# locale                            = try(var.ipam_configuration[each.key].locale, null)
# allocation_default_netmask_length = try(var.ipam_configuration[each.key].allocation_default_netmask_length, null)
# allocation_max_netmask_length     = try(var.ipam_configuration[each.key].allocation_max_netmask_length, null)
# allocation_min_netmask_length     = try(var.ipam_configuration[each.key].allocation_min_netmask_length, null)
# # allocation_resource_tags = try(var.ipam_configuration[each.key].allocation_resource_tags, null)
# auto_import = try(var.ipam_configuration[each.key].auto_import, null)
# # aws_service = try(var.ipam_configuration[each.key].aws_service, null)

# resource "aws_vpc_ipam_pool_cidr" "mid" {
#   for_each = toset(local.mid_tier_pool_names)

#   ipam_pool_id = aws_vpc_ipam_pool.mid[each.key].id
#   cidr         = var.ipam_configuration[each.key].mid_tier_cidr

  # depends_on = [
  #   aws_vpc_ipam_pool_cidr.top
  # ]
#



# resource "aws_vpc_ipam_pool" "regional" {
#   for_each = toset(local.regional_pools)

#   address_family = "ipv4"
#   ipam_scope_id  = aws_vpc_ipam.main.private_default_scope_id
#   source_ipam_pool_id = aws_vpc_ipam_pool.mid[split("/", each.key)[0]].id
#   locale = split("/", each.key)[1]
# }

# resource "aws_vpc_ipam_pool_cidr" "regional" {
#   for_each = toset(local.regional_pools)

#   ipam_pool_id = aws_vpc_ipam_pool.regional[each.key].id
#   cidr         = var.ipam_configuration[split("/", each.key)[0]][split("/", each.key)[1]].cidr

#   depends_on = [
#     aws_vpc_ipam_pool_cidr.mid
#   ]
# }

