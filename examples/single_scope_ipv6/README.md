<!-- BEGIN_TF_DOCS -->
## IPv6 Basic Deployment

The example shows you how to build an IPAM and populate the public scope with IPv6.

![IPv6 Pool structure](../../images/ipv6\_example.png "Region Separated Pools")

## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ipv6_basic"></a> [ipv6\_basic](#module\_ipv6\_basic) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_authorization_context_cidr"></a> [cidr\_authorization\_context\_cidr](#input\_cidr\_authorization\_context\_cidr) | CIDR Authorization Context CIDR. MUST MATCH a cidr in var.ipv6\_cidr | `any` | n/a | yes |
| <a name="input_cidr_authorization_context_message"></a> [cidr\_authorization\_context\_message](#input\_cidr\_authorization\_context\_message) | CIDR Authorization Context Message. | `any` | n/a | yes |
| <a name="input_cidr_authorization_context_signature"></a> [cidr\_authorization\_context\_signature](#input\_cidr\_authorization\_context\_signature) | CIDR Authorization Context Signature. | `any` | n/a | yes |
| <a name="input_ipv6_cidr"></a> [ipv6\_cidr](#input\_ipv6\_cidr) | Top CIDR IPv6. | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->