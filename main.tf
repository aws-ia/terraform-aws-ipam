locals {
  # mid pools without the top_tier_cidr
  mid_tier_pools = {for k, v in var.ipam_configuration : k => v if k != "top_tier_cidr"}
  # names of the mid_tier_pools
  mid_tier_pool_names = keys(local.mid_tier_pools)
  # each mid_tier_pool_name with a list of regional pools to create
  list_regions_per_mid_pool = {for mid_name, mid_v in local.mid_tier_pools : mid_name => [for i, v2 in mid_v : i if i != "mid_tier_cidr"]}
  # list of all operating regions declared in ipam_configuration, used to set ipam.operating_regions
  operating_regions = toset(concat(flatten(values(local.list_regions_per_mid_pool)), [data.aws_region.current.name] ))
  # list of all regional pools to be created formatted `<mid_tier_pool_name>/region`
  regional_pools = flatten([for mid, regions in local.list_regions_per_mid_pool : [for _, region in regions: "${mid}/${region}"]])
}

data "aws_region" "current" {}

resource "aws_vpc_ipam" "main" {
  description = "IPAM with primary in ${data.aws_region.current.name}"
  dynamic operating_regions {
    for_each = local.operating_regions
    content {
      region_name = operating_regions.key
    }
  }
}

resource "aws_vpc_ipam_pool" "top" {
  address_family = "ipv4"
  ipam_scope_id  = aws_vpc_ipam.main.private_default_scope_id
}

resource "aws_vpc_ipam_pool_cidr" "top" {
  ipam_pool_id = aws_vpc_ipam_pool.top.id
  cidr         = var.ipam_configuration.top_tier_cidr
}

resource "aws_vpc_ipam_pool" "mid" {
  for_each = toset(local.mid_tier_pool_names)

  address_family = "ipv4"
  ipam_scope_id  = aws_vpc_ipam.main.private_default_scope_id
  source_ipam_pool_id = aws_vpc_ipam_pool.top.id
}

resource "aws_vpc_ipam_pool_cidr" "mid" {
  for_each = toset(local.mid_tier_pool_names)

  ipam_pool_id = aws_vpc_ipam_pool.mid[each.key].id
  cidr         = var.ipam_configuration[each.key].mid_tier_cidr

  depends_on = [
    aws_vpc_ipam_pool_cidr.top
  ]
}

resource "aws_vpc_ipam_pool" "regional" {
  for_each = toset(local.regional_pools)

  address_family = "ipv4"
  ipam_scope_id  = aws_vpc_ipam.main.private_default_scope_id
  source_ipam_pool_id = aws_vpc_ipam_pool.mid[split("/", each.key)[0]].id
  locale = split("/", each.key)[1]
}

resource "aws_vpc_ipam_pool_cidr" "regional" {
  for_each = toset(local.regional_pools)

  ipam_pool_id = aws_vpc_ipam_pool.regional[each.key].id
  cidr         = var.ipam_configuration[split("/", each.key)[0]][split("/", each.key)[1]].cidr

  depends_on = [
    aws_vpc_ipam_pool_cidr.mid
  ]
}
