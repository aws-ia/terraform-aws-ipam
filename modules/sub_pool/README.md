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
| <a name="input_pool_config"></a> [pool\_config](#input\_pool\_config) | Configuration of the Pool you want to deploy. All aws\_vpc\_ipam\_pool arguments are available as well as ram\_share\_principals list and sub\_pools map (up to 3 levels). | <pre>object({<br>    cidr                 = optional(list(string))<br>    ram_share_principals = optional(list(string))<br><br>    locale                            = optional(string)<br>    allocation_default_netmask_length = optional(string)<br>    allocation_max_netmask_length     = optional(string)<br>    allocation_min_netmask_length     = optional(string)<br>    auto_import                       = optional(string)<br>    aws_service                       = optional(string)<br>    description                       = optional(string)<br>    name                              = optional(string)<br>    netmask_length                    = optional(number)<br>    publicly_advertisable             = optional(bool)<br>    public_ip_source                  = optional(string)<br><br>    allocation_resource_tags = optional(map(string))<br>    tags                     = optional(map(string))<br><br>    sub_pools = optional(any)<br>  })</pre> | n/a | yes |
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
<!-- END_TF_DOCS --><!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.34 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.6.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | 0.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.34 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.10.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_label"></a> [label](#module\_label) | cloudposse/label/null | 0.25.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ram_principal_association.sub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association) | resource |
| [aws_ram_resource_association.sub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association) | resource |
| [aws_ram_resource_share.sub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share) | resource |
| [aws_vpc_ipam_pool.sub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool) | resource |
| [aws_vpc_ipam_pool_cidr.sub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool_cidr) | resource |
| [time_static.creation](https://registry.terraform.io/providers/hashicorp/time/0.10.0/docs/resources/static) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_role"></a> [access\_role](#input\_access\_role) | Role used by IAM boundaries to permit access withing defined boundaries | `string` | `null` | no |
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br>This is for some rare cases where resources want additional configuration of tags<br>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_address_family"></a> [address\_family](#input\_address\_family) | IPv4/6 address family. | `string` | n/a | yes |
| <a name="input_aft_managed"></a> [aft\_managed](#input\_aft\_managed) | AFT managed | `string` | `"true"` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br>in the order they appear in the list. New attributes are appended to the<br>end of the list. The elements of the list are joined by the `delimiter`<br>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_aws_deployment_profile"></a> [aws\_deployment\_profile](#input\_aws\_deployment\_profile) | Name of AWS Profile to use for Deployment | `string` | `null` | no |
| <a name="input_aws_deployment_role"></a> [aws\_deployment\_role](#input\_aws\_deployment\_role) | Name of AWS Role to use for Deployment | `string` | `null` | no |
| <a name="input_aws_prefix_external"></a> [aws\_prefix\_external](#input\_aws\_prefix\_external) | Prefix for external resources | `string` | `"global/platform/external"` | no |
| <a name="input_aws_prefix_internal"></a> [aws\_prefix\_internal](#input\_aws\_prefix\_internal) | Prefix for internal resources | `string` | `"global/platform/internal"` | no |
| <a name="input_aws_prefix_service"></a> [aws\_prefix\_service](#input\_aws\_prefix\_service) | Prefix for service resources | `string` | `"global/platform/services"` | no |
| <a name="input_aws_principal_org_id"></a> [aws\_principal\_org\_id](#input\_aws\_principal\_org\_id) | AWS Organizations ID string for the remote state trust policy | `string` | `null` | no |
| <a name="input_cidr_authorization_contexts"></a> [cidr\_authorization\_contexts](#input\_cidr\_authorization\_contexts) | A list of signed documents that proves that you are authorized to bring the specified IP address range to Amazon using BYOIP. Document is not stored in the state file. For more information, refer to https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool_cidr#cidr_authorization_context. | <pre>list(object({<br>    cidr      = string<br>    message   = string<br>    signature = string<br>  }))</pre> | `[]` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "descriptor_formats": {},<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "labels_as_tags": [<br>    "default"<br>  ],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {},<br>  "tenant": null<br>}</pre> | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br>Map of maps. Keys are names of descriptors. Values are maps of the form<br>`{<br>   format = string<br>   labels = list(string)<br>}`<br>(Type is `any` so the map values can later be enhanced to provide additional options.)<br>`format` is a Terraform format string to be passed to the `format()` function.<br>`labels` is a list of labels, in order, to pass to `format()` function.<br>Label values will be normalized before being passed to `format()` so they will be<br>identical to how they appear in `id`.<br>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Used to define either 'live' or 'sdlc' environment type. (Live = Production and Staging, SDLC = QA, Development, Sandbox, and all other types | `string` | `null` | no |
| <a name="input_git_repo"></a> [git\_repo](#input\_git\_repo) | Git Repository for making changes to this configuration | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for keep the existing setting, which defaults to `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_implied_description"></a> [implied\_description](#input\_implied\_description) | Description is implied from the pool tree name <parent>/<child> unless specified on the pool\_config. | `string` | `null` | no |
| <a name="input_implied_locale"></a> [implied\_locale](#input\_implied\_locale) | Locale is implied from a parent pool even if another is specified. Its not possible to set child pools to different locales. | `string` | `"None"` | no |
| <a name="input_implied_name"></a> [implied\_name](#input\_implied\_name) | Name is implied from the pool tree name <parent>/<child> unless specified on the pool\_config. | `string` | `null` | no |
| <a name="input_ipam_scope_id"></a> [ipam\_scope\_id](#input\_ipam\_scope\_id) | IPAM Scope ID to attach the pool to. | `string` | n/a | yes |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br>Does not affect keys of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br>set as tag values, and output by this module individually.<br>Does not affect values of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br>Default is to include all labels.<br>Tags with empty values will not be included in the `tags` output.<br>Set to `[]` to suppress all generated tags.<br>**Notes:**<br>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| <a name="input_monitored_by"></a> [monitored\_by](#input\_monitored\_by) | MonitoredBy tag | `string` | `"cloudwatch"` | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br>This is the only ID element not also included as a `tag`.<br>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_pool_config"></a> [pool\_config](#input\_pool\_config) | Configuration of the Pool you want to deploy. All aws\_vpc\_ipam\_pool arguments are available as well as ram\_share\_principals list and sub\_pools map (up to 3 levels). | <pre>object({<br>    cidr                 = optional(list(string))<br>    ram_share_principals = optional(list(string))<br><br>    locale                            = optional(string)<br>    allocation_default_netmask_length = optional(string)<br>    allocation_max_netmask_length     = optional(string)<br>    allocation_min_netmask_length     = optional(string)<br>    auto_import                       = optional(string)<br>    aws_service                       = optional(string)<br>    description                       = optional(string)<br>    name                              = optional(string)<br>    netmask_length                    = optional(number)<br>    publicly_advertisable             = optional(bool)<br>    public_ip_source                  = optional(string)<br><br>    allocation_resource_tags = optional(map(string))<br>    tags                     = optional(map(string))<br><br>    sub_pools = optional(any)<br>  })</pre> | n/a | yes |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br>Characters matching the regex will be removed from the ID elements.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_source_ipam_pool_id"></a> [source\_ipam\_pool\_id](#input\_source\_ipam\_pool\_id) | IPAM parent pool ID to attach the pool to. | `string` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'Production', 'Staging', 'QA', 'Development', 'Sandbox' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element. A team identifier, indicating which team owns this resource | `string` | `null` | no |
| <a name="input_terraform_managed"></a> [terraform\_managed](#input\_terraform\_managed) | Terraform managed | `string` | `"true"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cidr"></a> [cidr](#output\_cidr) | CIDR provisioned to pool. |
| <a name="output_pool"></a> [pool](#output\_pool) | Pool information. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
