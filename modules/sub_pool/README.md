<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.53.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.53.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ram_principal_association.sub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association) | resource |
| [aws_ram_resource_association.sub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association) | resource |
| [aws_ram_resource_share.sub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share) | resource |
| [aws_vpc_ipam_pool.sub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool) | resource |
| [aws_vpc_ipam_pool_cidr.sub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool_cidr) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_family"></a> [address\_family](#input\_address\_family) | IPv4/6 address family. | `string` | n/a | yes |
| <a name="input_ipam_scope_id"></a> [ipam\_scope\_id](#input\_ipam\_scope\_id) | IPAM Scope ID to attach the pool to. | `string` | n/a | yes |
| <a name="input_pool_config"></a> [pool\_config](#input\_pool\_config) | Configuration of the Pool you want to deploy. All aws\_vpc\_ipam\_pool arguments are available as well as ram\_share\_principals list and sub\_pools map (up to 3 levels). | <pre>object({<br>    cidr                 = optional(list(string))<br>    ram_share_principals = optional(list(string))<br><br>    locale                            = optional(string)<br>    allocation_default_netmask_length = optional(string)<br>    allocation_max_netmask_length     = optional(string)<br>    allocation_min_netmask_length     = optional(string)<br>    auto_import                       = optional(string)<br>    aws_service                       = optional(string)<br>    description                       = optional(string)<br>    name                              = optional(string)<br>    netmask_length                    = optional(number)<br>    publicly_advertisable             = optional(bool)<br><br>    allocation_resource_tags = optional(map(string))<br>    tags                     = optional(map(string))<br><br>    sub_pools = optional(any)<br>  })</pre> | n/a | yes |
| <a name="input_source_ipam_pool_id"></a> [source\_ipam\_pool\_id](#input\_source\_ipam\_pool\_id) | IPAM parent pool ID to attach the pool to. | `string` | n/a | yes |
| <a name="input_cidr_authorization_contexts"></a> [cidr\_authorization\_contexts](#input\_cidr\_authorization\_contexts) | A list of signed documents that proves that you are authorized to bring the specified IP address range to Amazon using BYOIP. Document is not stored in the state file. For more information, refer to https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool_cidr#cidr_authorization_context. | <pre>list(object({<br>    cidr      = string<br>    message   = string<br>    signature = string<br>  }))</pre> | `[]` | no |
| <a name="input_implied_description"></a> [implied\_description](#input\_implied\_description) | Description is implied from the pool tree name <parent>/<child> unless specified on the pool\_config. | `string` | `null` | no |
| <a name="input_implied_locale"></a> [implied\_locale](#input\_implied\_locale) | Locale is implied from a parent pool even if another is specified. Its not possible to set child pools to different locales. | `string` | `"None"` | no |
| <a name="input_implied_name"></a> [implied\_name](#input\_implied\_name) | Name is implied from the pool tree name <parent>/<child> unless specified on the pool\_config. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cidr"></a> [cidr](#output\_cidr) | CIDR provisioned to pool. |
| <a name="output_pool"></a> [pool](#output\_pool) | Pool information. |
<!-- END_TF_DOCS -->