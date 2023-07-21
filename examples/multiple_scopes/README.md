<!-- BEGIN_TF_DOCS -->
## Multiple Scopes

There are several reasons you may want to populate multiple IPAM scopes:

- Public & Private scope
- IPv4 + IPv6
- Overlapping IPv4 ranges

This example shows you how to build scopes for 2 overlapping IPv4 ranges that you want IPAM to manage. You do this by:

1. invoke module to build IPAM + ipv4 pool\_configuration
2. create a new private scope on the IPAM built in step 1
3. invoke module with `create_ipam = false` and pass in the new scope id created

For IPv4 + IPv6, skip step 2. Reference the `public_default_scope_id` from the ipam in step 1 instead of creating a new scope.

![Multiple Scopes](../../images/multiple\_ipv4\_scopes.png "Multiple Scopes")

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | = 4.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | = 4.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ipv4_scope"></a> [ipv4\_scope](#module\_ipv4\_scope) | ../.. | n/a |
| <a name="module_overlapping_cidr_second_ipv4_scope"></a> [overlapping\_cidr\_second\_ipv4\_scope](#module\_overlapping\_cidr\_second\_ipv4\_scope) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_vpc_ipam_scope.scope_for_overlapping_cidr](https://registry.terraform.io/providers/hashicorp/aws/4.2/docs/resources/vpc_ipam_scope) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr"></a> [cidr](#input\_cidr) | n/a | `string` | `"10.0.0.0/8"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->