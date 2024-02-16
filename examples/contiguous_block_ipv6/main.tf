module "ipv6_contiguous" {
  # source  = "aws-ia/ipam/aws"
  source = "../.."

  top_cidr                  = null
  top_netmask_length        = "52"
  address_family            = "ipv6"
  ipam_scope_type           = "public"
  top_aws_service           = "ec2"
  top_publicly_advertisable = false
  top_public_ip_source      = "amazon"
  top_locale                = "us-east-1"

  ipam_pool_configurations = {
    us-east-1 = {
      name                  = "ipv6 us-east-1"
      description           = "pool for ipv6 us-east-1"
      netmask_length        = "55"
      locale                = "us-east-1"
      aws_service           = "ec2"
      publicly_advertisable = false
      public_ip_source      = "amazon"

      sub_pools = {
        team_a = {
          name                  = "team_a"
          netmask_length        = "56"
          aws_service           = "ec2"
          publicly_advertisable = false
          public_ip_source      = "amazon"
        }
      }
    }
  }
}
