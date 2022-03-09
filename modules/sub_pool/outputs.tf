output "pool" {
  description = "Pool information."
  value       = aws_vpc_ipam_pool.sub
}

output "cidr" {
  description = "CIDR provisioned to pool."
  value       = aws_vpc_ipam_pool_cidr.sub
}
