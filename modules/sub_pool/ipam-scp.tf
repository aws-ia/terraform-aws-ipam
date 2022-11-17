# The following resources are added outside of
# https://github.com/aws-ia/terraform-aws-ipam/tree/v1.1.4
# https://registry.terraform.io/modules/aws-ia/ipam/aws/latest


locals {
  scp_enabled = try(length(var.pool_config.ram_share_principals), 0) > 0 && var.pool_config.create_scp
}

resource "aws_organizations_policy" "restrict_ipam_pools" {
  #This should get deployed to root account
  provider = aws.root

  for_each    = local.scp_enabled ? toset(var.pool_config.ram_share_principals) : []
  name        = "Restrict IPAM Pool Acc # ${each.key}"
  description = "Restrict IPAM pool for Acc # ${each.key}"

  content = jsonencode({
    statement = {
      sid       = "RestrictIpamPools"
      effect    = "Deny"
      actions   = ["ec2:CreateVpc", "ec2:AssociateVpcCidrBlock"]
      resources = ["arn:aws:ec2:${var.implied_locale != "None" ? var.implied_locale : var.pool_config.locale}:*:vpc/*"]

      condition = {
        test     = "StringNotEquals"
        variable = "ec2:Ipv4IpamPoolId"
        values   = [aws_vpc_ipam_pool.sub.id]
      }
    }
  })
}

resource "aws_organizations_policy_attachment" "restrict_ipam_pools_scp_target" {
  #This should get deployed to root account
  provider = aws.root

  for_each  = local.scp_enabled ? toset(var.pool_config.ram_share_principals) : []
  policy_id = aws_organizations_policy.restrict_ipam_pools[each.key].id
  target_id = each.key
}