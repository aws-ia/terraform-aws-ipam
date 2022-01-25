output "top_level_pool" {
    value = aws_vpc_ipam_pool.top
}

output "mid_level_pools" {
    value = aws_vpc_ipam_pool.mid
}

output "region_level_pools" {
    value = aws_vpc_ipam_pool.regional
}
