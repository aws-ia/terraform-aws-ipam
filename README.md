<!-- BEGIN_TF_DOCS -->
# Terraform Module for Amazon VPC IP Address Manager on AWS

<i>Note: For information regarding the 2.0 upgrade see our [upgrade guide](https://github.com/aws-ia/terraform-aws-ipam/blob/main/docs/UPGRADE-GUIDE-2.0.md).</i>

This module helps deploy AWS IPAM including IPAM Pools, Provisioned CIDRs, and can help with sharing those pools via AWS RAM.

Built to accommodate a wide range of use cases, this Terraform module can deploy both simple and complex Amazon Virtual Private Cloud (Amazon VPC) IP Address Manager (IPAM) configurations. It supports both symmetrically nested, multi-Region deployments (most common IPAM designs) as well as [asymmetically nested deployments](https://github.com/aws-ia/terraform-aws-ipam/blob/main/images/asymmetrical_example.png).

Refer to the [examples/](https://github.com/aws-ia/terraform-aws-ipam/blob/main/examples) directory in this GitHub repository for examples.

The embedded example below describes a symmetrically nested pool structure, including its configuration, implementation details, requirements, and more.

## Architecture Example

<p align="center">
  <img src="https://raw.githubusercontent.com/aws-ia/terraform-aws-ipam/main/images/ipam_symmetrical.png" alt="symmetrically nested pool deployment" width="100%">
</p>

\_Note: The diagram above is an example of the type of Pool design you can deploy using this module.\_

## Configuration
This module strongly relies on the `var.pool_configuration` variable, which is a multi-level, nested map that describes how to nest your IPAM pools. It can accept most `aws_vpc_ipam_pool` and `aws_vpc_ipam_pool_cidr` attributes (detailed below) as well as RAM share pools (at any level) to valid AWS principals. Nested pools do not inherit attributes from their source pool(s), so all configuration options are available at each level. `locale` is implied in sub pools after declared in a parent.

In this module, pools can be nested up to four levels, including one root pool and up to three nested pools. The root pool defines the `address_family` variable. If you want to deploy an IPv4 and IPv6 pool structure, you must instantiate the module for each type.

The `pool_configurations` variable is the structure of the other three levels. The `sub_pool` submodule has a `var.pool_config` variable that defines the structure that each pool can accept. The variable has the following structure:

```
pool_configurations = {
  my_pool_name = {
    description      = "my pool"
    cidr             = ["10.0.0.0/16"]
    locale           = "us-east-1"

    sub_pools = {

      sandbox = {
        cidr = ["10.0.48.0/20"]
        ram_share_principals = [local.dev_ou_arn]
        # ...any pool_config argument (below)
      }
    }
  }
}
```

The key of a `pool_config` variable is the name of the pool, followed by its attributes `ram_share_principals` and a `sub_pools` map, which is another nested `pool_config` variable.

```terraform
variable "pool_config" {
  type = object({
    cidr                 = list(string)
    ram_share_principals = optional(list(string))

    name                              = optional(string)
    locale                            = optional(string)
    allocation_default_netmask_length = optional(string)
    allocation_max_netmask_length     = optional(string)
    allocation_min_netmask_length     = optional(string)
    auto_import                       = optional(string)
    aws_service                       = optional(string)
    description                       = optional(string)
    publicly_advertisable             = optional(bool)

    allocation_resource_tags   = optional(map(string))
    tags                       = optional(map(string))

    sub_pools = optional(any)
  })
}
```

## RAM Sharing

This module allows you to share invidual pools to any valid RAM principal. All levels of `var.pool_configurations` accept an argument `ram_share_principals` which should be a list of valid RAM share principals (org-id, ou-id, or account id).

## Using Outputs

Since resources are dynamically generated based on user configuration, we roll them into grouped outputs. For example, to get attributes off your level 2 pools:

The output `pools_level_2` offers you a map of every pool where the name is the route of the tree keys [example `"corporate-us-west-2/dev"`](https://github.com/aws-ia/terraform-aws-ipam/blob/a7d508cb0be2f68d99952682c2392b6d7d541d96/examples/single_scope_ipv4/main.tf#L28).

To get a specific ID:
```
> module.basic.pools_level_2["corporate-us-west-2/dev"].id
"ipam-pool-0c816929a16f08747"
```

To get all IDs
```terraform
> [ for pool in module.basic.pools_level_2: pool["id"]]
[
  "ipam-pool-0c816929a16f08747",
  "ipam-pool-0192c70b370384661",
  "ipam-pool-037bb0524f8b3278e",
  "ipam-pool-09400d26a6d1df4a5",
  "ipam-pool-0ee5ebe8f8d2d7187",
]
```

## Implementation

### Implied pool names and descriptions

By default, pool `Name` tags and pool descriptions are implied from the name-hierarchy structure of the pool. For example, a pool with two parents `us-east-1` and `dev` has an implied name and description value of `us-east-1/dev`. You can override either or both name and description at any pool level by specifying a `name` or `description` value.

### Locales

IPAM pools do not inherit attributes from their parent pools. Locales cannot change from parent to child. For that reason, after a pool in the `var.pool_configurations` variable defines a `locale` value, all other child pools have an `implied_locale` value.

### Operating Regions

The IPAM `operating_region` variable must be set for the primary Region in your Terraform provider block and any Regions you want to set a `locale`. For that reason, the value of the `aws_vpc_ipam.operating_regions` variable is constructed by combining the  `pool_configurations` and `data.aws_region.current.name` attributes.

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
| <a name="module_level_one"></a> [level\_one](#module\_level\_one) | ./modules/sub_pool | n/a |
| <a name="module_level_three"></a> [level\_three](#module\_level\_three) | ./modules/sub_pool | n/a |
| <a name="module_level_two"></a> [level\_two](#module\_level\_two) | ./modules/sub_pool | n/a |
| <a name="module_level_zero"></a> [level\_zero](#module\_level\_zero) | ./modules/sub_pool | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_vpc_ipam.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam) | resource |
| [time_static.creation](https://registry.terraform.io/providers/hashicorp/time/0.10.0/docs/resources/static) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_role"></a> [access\_role](#input\_access\_role) | Role used by IAM boundaries to permit access withing defined boundaries | `string` | `null` | no |
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br>This is for some rare cases where resources want additional configuration of tags<br>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_address_family"></a> [address\_family](#input\_address\_family) | IPv4/6 address family. | `string` | `"ipv4"` | no |
| <a name="input_aft_managed"></a> [aft\_managed](#input\_aft\_managed) | AFT managed | `string` | `"true"` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br>in the order they appear in the list. New attributes are appended to the<br>end of the list. The elements of the list are joined by the `delimiter`<br>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_aws_deployment_profile"></a> [aws\_deployment\_profile](#input\_aws\_deployment\_profile) | Name of AWS Profile to use for Deployment | `string` | `null` | no |
| <a name="input_aws_deployment_role"></a> [aws\_deployment\_role](#input\_aws\_deployment\_role) | Name of AWS Role to use for Deployment | `string` | `null` | no |
| <a name="input_aws_prefix_external"></a> [aws\_prefix\_external](#input\_aws\_prefix\_external) | Prefix for external resources | `string` | `"global/platform/external"` | no |
| <a name="input_aws_prefix_internal"></a> [aws\_prefix\_internal](#input\_aws\_prefix\_internal) | Prefix for internal resources | `string` | `"global/platform/internal"` | no |
| <a name="input_aws_prefix_service"></a> [aws\_prefix\_service](#input\_aws\_prefix\_service) | Prefix for service resources | `string` | `"global/platform/services"` | no |
| <a name="input_aws_principal_org_id"></a> [aws\_principal\_org\_id](#input\_aws\_principal\_org\_id) | AWS Organizations ID string for the remote state trust policy | `string` | `null` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "descriptor_formats": {},<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "labels_as_tags": [<br>    "default"<br>  ],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {},<br>  "tenant": null<br>}</pre> | no |
| <a name="input_create_ipam"></a> [create\_ipam](#input\_create\_ipam) | Determines whether to create an IPAM. If `false`, you must also provide a var.ipam\_scope\_id. | `bool` | `true` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br>Map of maps. Keys are names of descriptors. Values are maps of the form<br>`{<br>   format = string<br>   labels = list(string)<br>}`<br>(Type is `any` so the map values can later be enhanced to provide additional options.)<br>`format` is a Terraform format string to be passed to the `format()` function.<br>`labels` is a list of labels, in order, to pass to `format()` function.<br>Label values will be normalized before being passed to `format()` so they will be<br>identical to how they appear in `id`.<br>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Used to define either 'live' or 'sdlc' environment type. (Live = Production and Staging, SDLC = QA, Development, Sandbox, and all other types | `string` | `null` | no |
| <a name="input_git_repo"></a> [git\_repo](#input\_git\_repo) | Git Repository for making changes to this configuration | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for keep the existing setting, which defaults to `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_ipam_scope_id"></a> [ipam\_scope\_id](#input\_ipam\_scope\_id) | (Optional) Required if `var.ipam_id` is set. Determines which scope to deploy pools into. | `string` | `null` | no |
| <a name="input_ipam_scope_type"></a> [ipam\_scope\_type](#input\_ipam\_scope\_type) | Which scope type to use. Valid inputs include `public` or `private`. You can alternatively provide your own scope ID. | `string` | `"private"` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br>Does not affect keys of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br>set as tag values, and output by this module individually.<br>Does not affect values of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br>Default is to include all labels.<br>Tags with empty values will not be included in the `tags` output.<br>Set to `[]` to suppress all generated tags.<br>**Notes:**<br>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| <a name="input_monitored_by"></a> [monitored\_by](#input\_monitored\_by) | MonitoredBy tag | `string` | `"cloudwatch"` | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br>This is the only ID element not also included as a `tag`.<br>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_pool_configurations"></a> [pool\_configurations](#input\_pool\_configurations) | A multi-level, nested map describing nested IPAM pools. Can nest up to three levels with the top level being outside the `pool_configurations` in vars prefixed `top_`. If arugument descriptions are omitted, you can find them in the [official documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool#argument-reference).<br><br>- `ram_share_principals` = (optional, list(string)) of valid organization principals to create ram shares to.<br>- `name`                 = (optional, string) name to give the pool, the key of your map in var.pool\_configurations will be used if omitted.<br>- `description`          = (optional, string) description to give the pool, the key of your map in var.pool\_configurations will be used if omitted.<br>- `cidr`                 = (optional, list(string)) list of CIDRs to provision into pool. Conflicts with `netmask_length`.<br>- `netmask_length`       = (optional, number) netmask length to request provisioned into pool. Conflicts with `cidr`.<br><br>- `locale`      = (optional, string) locale to set for pool.<br>- `auto_import` = (optional, string)<br>- `tags`        = (optional, map(string))<br>- `allocation_default_netmask_length` = (optional, string)<br>- `allocation_max_netmask_length`     = (optional, string)<br>- `allocation_min_netmask_length`     = (optional, string)<br>- `allocation_resource_tags`          = (optional, map(string))<br><br>The following arguments are available but only relevant for public ips<br>- `cidr_authorization_context` = (optional, map(string)) Details found in [official documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool_cidr#cidr_authorization_context).<br>- `aws_service`                = (optional, string)<br>- `publicly_advertisable`      = (optional, bool)<br><br>- `sub_pools` = (nested repeats of pool\_configuration object above) | `any` | `{}` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br>Characters matching the regex will be removed from the ID elements.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'Production', 'Staging', 'QA', 'Development', 'Sandbox' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element. A team identifier, indicating which team owns this resource | `string` | `null` | no |
| <a name="input_terraform_managed"></a> [terraform\_managed](#input\_terraform\_managed) | Terraform managed | `string` | `"true"` | no |
| <a name="input_top_auto_import"></a> [top\_auto\_import](#input\_top\_auto\_import) | `auto_import` setting for top-level pool. | `bool` | `null` | no |
| <a name="input_top_aws_service"></a> [top\_aws\_service](#input\_top\_aws\_service) | AWS service, for usage with public IPs. Valid values "ec2". | `string` | `null` | no |
| <a name="input_top_cidr"></a> [top\_cidr](#input\_top\_cidr) | Top-level CIDR blocks. | `list(string)` | `null` | no |
| <a name="input_top_cidr_authorization_contexts"></a> [top\_cidr\_authorization\_contexts](#input\_top\_cidr\_authorization\_contexts) | CIDR must match a CIDR defined in `var.top_cidr`. A list of signed documents that proves that you are authorized to bring the specified IP address range to Amazon using BYOIP. Document is not stored in the state file. For more information, refer to https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool_cidr#cidr_authorization_context. | <pre>list(object({<br>    cidr      = string<br>    message   = string<br>    signature = string<br>  }))</pre> | `[]` | no |
| <a name="input_top_description"></a> [top\_description](#input\_top\_description) | Description of top-level pool. | `string` | `""` | no |
| <a name="input_top_locale"></a> [top\_locale](#input\_top\_locale) | locale of the top-level pool. Do not use this value unless building an ipv6 contiguous block pool. You will have to instantiate the module for each operating region you want a pool structure in. | `string` | `null` | no |
| <a name="input_top_name"></a> [top\_name](#input\_top\_name) | Name of top-level pool. | `string` | `null` | no |
| <a name="input_top_netmask_length"></a> [top\_netmask\_length](#input\_top\_netmask\_length) | Top-level netmask length to request. Not possible to use for IPv4. Only possible to use with amazon provided ipv6. | `number` | `null` | no |
| <a name="input_top_public_ip_source"></a> [top\_public\_ip\_source](#input\_top\_public\_ip\_source) | public IP source for usage with public IPs. Valid values "amazon" or "byoip". | `string` | `null` | no |
| <a name="input_top_publicly_advertisable"></a> [top\_publicly\_advertisable](#input\_top\_publicly\_advertisable) | Whether or not the top-level pool is publicly advertisable. | `bool` | `null` | no |
| <a name="input_top_ram_share_principals"></a> [top\_ram\_share\_principals](#input\_top\_ram\_share\_principals) | Principals to create RAM shares for top-level pool. | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ipam_info"></a> [ipam\_info](#output\_ipam\_info) | If created, ouput the IPAM object information. |
| <a name="output_operating_regions"></a> [operating\_regions](#output\_operating\_regions) | List of all IPAM operating regions. |
| <a name="output_pool_level_0"></a> [pool\_level\_0](#output\_pool\_level\_0) | Map of all pools at level 0. |
| <a name="output_pool_names"></a> [pool\_names](#output\_pool\_names) | List of all pool names. |
| <a name="output_pools_level_1"></a> [pools\_level\_1](#output\_pools\_level\_1) | Map of all pools at level 1. |
| <a name="output_pools_level_2"></a> [pools\_level\_2](#output\_pools\_level\_2) | Map of all pools at level 2. |
| <a name="output_pools_level_3"></a> [pools\_level\_3](#output\_pools\_level\_3) | Map of all pools at level 3. |
<!-- END_TF_DOCS -->